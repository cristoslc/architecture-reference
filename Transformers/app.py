from flask import Flask, render_template, request, jsonify
import os
import warnings
from langchain_groq import ChatGroq
from langchain.chains import LLMChain, create_retrieval_chain
import pandas as pd
from langchain_openai import ChatOpenAI  # Use ChatOpenAI for chat models
from langchain_experimental.agents import create_pandas_dataframe_agent
from translate import Translator
from dotenv import load_dotenv
load_dotenv()

app = Flask(__name__)

# Suppress warnings
warnings.filterwarnings("ignore", message=".*clean_up_tokenization_spaces.*")


open_api_key = os.getenv("OPENAI_API_KEY")
STATIC_PDF_FOLDER = "uploads"



# Global variables
index = None
query_chain = None
chat_history = []
language_code={
    "language":'english',
    "code": "en"

}

# Helper function for translations
def translate_text(text, target_language):
    translator = Translator(to_lang=target_language)
    return translator.translate(text)



# Home route
@app.route('/')
def home():
    return render_template('index.html')

@app.route('/start-chat')
def start_chat():
    load_status = True  # Load documents on startup
    username = request.args.get('username', 'Guest')
    language = request.args.get('language', 'English')
    language_code["language"]=language

    print(language)

    # Language code mapping
    language_codes = {
        "spanish": "es",
        "german": "de",
        "hindi": "hi",
        "french": "fr",
        "English": "en"
    }
    target_code = language_codes.get(language, "en")

    language_code["code"]=target_code
    print(target_code)
    # Translate the welcome message
    welcome_message = "How can I help you?"
    
    welcome_message = translate_text(welcome_message, target_code)

    print(f"Translated welcome message: {welcome_message}")

    return render_template('chat_bot.html', username=username, language=language, load_status=load_status, code=target_code, welcome_message=welcome_message)

# ------------------------------

from dotenv import load_dotenv
import os
import sqlite3
import google.generativeai as genai

def get_query_sql_response(question):
    """
    Takes a question as input, generates an SQL query using Google Gemini, executes the query on SQLite, 
    and returns the response. Returns a default message for invalid or unsupported questions.
    """
    # Load environment variables
    load_dotenv()

    # Configure GenAI API
    genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

    # Define prompt for Google Gemini
    prompt = [
        """
        You are an expert in converting English questions to SQL query!
        The SQL database of name data has only one table named Products with the following columns: 
        ProductID, ProductName, Category, CategoryID, OrderID, CustomerID, OrderStatus, ReturnEligible, 
        ShippingDate, MerchantID, ClusterID, ClusterLabel, Price, StockQuantity, Description, and Rating.
        if you found any general question like hi,how are you, good morning  like wise dont do sql query
        For example:
        Example 1 - How many entries of records are present? The SQL command will be: SELECT COUNT(*) FROM Products;
        
        Example 2 - Provide the details about ProductID 5? The SQL command will be: SELECT * FROM Products WHERE ProductID = 5;
        
        Example 2 - Provide the list of TV's? The SQL command will be: SELECT ProductName FROM Prodcuts WHERE Category = TVs;
        
        Example 4 - Provide the details about ProductID 5? SELECT * FROM Products WHERE ProductID = 5;
        
        Example 5 - What is the rating of ProductID 5? The SQL command will be : SELECT Rating FROM Products WHERE ProductID = 5;   

        Example 6 - List the TVs under $500? The SQL command will be : SELECT ProductName, Price FROM Products WHERE Category = 'TVs' AND Price < 500;    
        
        Example 7 - Which products are in stock? The SQL command will be : SELECT ProductName, StockQuantity FROM Products WHERE StockQuantity > 0;
        
        Example 8 - Find laptops under $1000 with at least 16GB RAM? The SQL command will be : SELECT ProductName, Price, Description FROM Products WHERE Category = 'Laptops' AND Price < 1000 AND Description LIKE '%16GB RAM%';

        Example 9 - Compare the average rating and price of smartphones and laptops in your catalog. The SQL command will be : SELECT Category, AVG(Rating) as AvgRating, AVG(Price) as AvgPrice FROM Products WHERE Category IN ('Smartphones', 'Laptops') GROUP BY Category;

        Example 10 - List products with a rating above 4.0 and priced under $500, but only if they are in stock. The SQL command will be : SELECT ProductName, Price, Rating FROM Products WHERE Rating > 4.0 AND Price < 500 AND StockQuantity > 0;

        Example 11 - Find the top 3 most expensive products purchased by Customer ID 5. The SQL command will be : SELECT ProductName, Price FROM Products WHERE CustomerID = 5 ORDER BY Price DESC LIMIT 3;

        Example 12 - What is the best-rated laptop under $1000? List its stock status and availability for delivery. The SQL command will be : SELECT ProductName, Rating, StockQuantity, OrderStatus FROM Products WHERE Category = 'Laptops' AND Price < 1000 ORDER BY Rating DESC LIMIT 1;

        Example 13 - Which product category has shown the highest average rating in the past 6 months? The SQL command will be : SELECT Category, AVG(Rating) as AvgRating FROM Products WHERE strftime('%Y-%m', ShippingDate) >= strftime('%Y-%m', 'now', '-6 months') GROUP BY Category ORDER BY AvgRating DESC LIMIT 1;

        Example 14 - Compare all available 4K TVs under $1000. Include their stock quantities, average rating, and price. The SQL command will be : SELECT ProductName, Price, StockQuantity, Rating FROM Products WHERE Category = 'TVs' AND Price < 1000 AND Description LIKE '%4K%' ORDER BY Rating DESC;

        Example 15 - Find products with the highest price-to-rating ratio in the 'Smartphones' category. The SQL command will be : SELECT ProductName, Price, Rating, (Price / Rating) as PriceToRatingRatio FROM Products WHERE Category = 'Smartphones' ORDER BY PriceToRatingRatio DESC LIMIT 1;

        Example 16 - Show the cheapest product in stock with at least 50 units and a rating above 4.0. The SQL command will be : SELECT ProductName, Price, StockQuantity, Rating FROM Products WHERE StockQuantity >= 50 AND Rating > 4.0 ORDER BY Price ASC LIMIT 1;

        Example 17 - Which product had the highest sales in the last 12 months? The SQL command will be : SELECT ProductName, COUNT(OrderID) as TotalSales FROM Products WHERE strftime('%Y-%m', ShippingDate) >= strftime('%Y-%m', 'now', '-12 months') GROUP BY ProductName ORDER BY TotalSales DESC LIMIT 1;

        Example 18 - List all products bought by Customer ID 5 in the last year, sorted by their rating. The SQL command will be : SELECT ProductName, Price, Rating, OrderID FROM Products WHERE CustomerID = 5 AND strftime('%Y-%m', ShippingDate) >= strftime('%Y-%m', 'now', '-12 months') ORDER BY Rating DESC;

        Example 19 - Identify the top 5 best-value products, calculated as (Rating * StockQuantity) / Price. The SQL command will be : SELECT ProductName, Price, Rating, StockQuantity, (Rating * StockQuantity / Price) as ValueScore FROM Products ORDER BY ValueScore DESC LIMIT 5;

        Example 20 - Which products are low in stock (less than 10 units) but highly rated (above 4.5)? The SQL command will be : SELECT ProductName, StockQuantity, Rating FROM Products WHERE StockQuantity < 10 AND Rating > 4.5;

        The output should only contain the SQL query without any additional formatting like ``` or "sql".


        """


    ]

    try:
        # Generate SQL query using Google Gemini
        model = genai.GenerativeModel('gemini-pro')
        sql_query = model.generate_content([prompt[0], question]).text.strip()
        print(f"Generated SQL Query: {sql_query}")

        # If the model's response doesn't resemble an SQL query, return the default message
        if not sql_query.lower().startswith("select") and not sql_query.lower().startswith("insert"):
            return "I am here to help with data, please ask a valid question."

        # Execute SQL query on SQLite database
        conn = sqlite3.connect("data.db")
        cur = conn.cursor()
        cur.execute(sql_query)
        rows = cur.fetchall()
        conn.commit()
        conn.close()

        # Return the query result if successful
        return rows if rows else "No results found for your query."
    except Exception as e:
        # Return a user-friendly error message in case of issues
        print(f"Error: {e}")
        return "I am here to help with data, please ask a valid question."



# ------------------RAG IMPLEMENTATION -------------------------------------------------------

from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate

# Define LLM for RAG (use your preferred LLM)
llm = ChatOpenAI(openai_api_key=open_api_key, temperature=0)

# Helper function to implement RAG
def generate_rag_response(user_query, sql_response):
    """
    Use RAG to refine the SQL response for the user query.
    Args:
        user_query (str): User's question
        sql_response (str): SQL query response
    Returns:
        str: Refined response for the user
    """
    # Define the prompt for the LLM
    prompt_template = PromptTemplate(
        input_variables=["user_query", "sql_response"],
        template=(
            "You are an intelligent assistant. You have been asked the question: '{user_query}'. "
            "You also have the following data retrieved from a database: '{sql_response}'. "
            "Generate a concise, human-readable response for the question based on the data provided."
            "if you receive an empty {sql_response} simply return please elaborate the question"
        )
    )
    
    # Create the chain with the LLM and the prompt template
    chain = LLMChain(llm=llm, prompt=prompt_template)

    # Generate a refined response
    refined_response = chain.run({"user_query": user_query, "sql_response": sql_response})
    return refined_response

# Update ask_question route with RAG integration
@app.route('/ask_question', methods=['POST'])
def ask_question():
    global query_chain, chat_history, language_code
    question = request.json.get('question')
    language = language_code["language"]
    target_code = language_code["code"]

    # Translate the question to English for querying
    english_question = question
    if target_code != "en":
        english_question = translate_text(question, target_language="en")

    # Add the question to chat history
    chat_history.append({"role": "user", "content": question})

    try:
        # Query with English question
        sql_response = get_query_sql_response(english_question)

        # Convert non-string responses to string before passing to RAG
        if not isinstance(sql_response, str):
            sql_response = str(sql_response)

        # Apply RAG: Use LLM to refine SQL response
        refined_response = generate_rag_response(english_question, sql_response)

        # Translate the response back to the selected language
        translated_response = refined_response
        if target_code != "en":
            translated_response = translate_text(refined_response, target_code)

        # Add response to chat history and return it
        chat_history.append({"role": "assistant", "content": translated_response})
        return jsonify({"response": translated_response})
    except Exception as e:
        print(f"Error during question answering: {str(e)}")
        return jsonify({"response": f"Error: {str(e)}"})






# -------------------------------

# Route to clear chat history
@app.route('/clear_all', methods=['POST'])
def clear_all():
    global chat_history
    chat_history.clear()  # Clear the chat history
    return jsonify({"status": "Cleared chat history."})

if __name__ == '__main__':

    app.run(debug=True, port=5000)
