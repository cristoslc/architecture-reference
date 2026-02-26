# Introduction
 
Welcome to the architectural story of ShopWise Assistant – the O'Reilly Winter 2024 Architectural Kata.
 
This challenge invites participants to design and build an AI-powered support assistant for ShopWise Solutions, blending advanced natural language understanding, seamless database integration, and user-centric features to create a cutting-edge customer service solution.
 
---
 
# Company Overview
 
Embark on a transformative data journey with **Vardaan Pioneering Data Sciences**—where innovation maximizes data potential, optimizing operations and streamlining processes for data-driven decision-making.

![Vardaan Data Sciences Logo](https://github.com/Syam916/oreally_sql/blob/master/vds%20(2).png)
 
Dedicated to knowledge-sharing, our training programs provide practical skills in the ever-changing world of data sciences. As a consultancy, we bridge the gap between raw data and actionable insights, delivering trends analysis and dashboards using advanced analytics, machine learning, and AI. Welcome to a future where **Vardaan Data Sciences Service** shapes a transformative path for organizations in the digital age.

---

**ShopWise Solutions** is a dynamic e-commerce website specializing in electronics and gadgets. Offering a wide range of high-quality products, from the latest smartphones and laptops to cutting-edge smart home devices and accessories, ShopWise caters to tech enthusiasts and everyday consumers alike. The platform focuses on providing a seamless shopping experience with detailed product descriptions, personalized recommendations, and robust customer support. With its commitment to innovation and user satisfaction, ShopWise Solutions stands as a go-to destination for all things tech in the online marketplace.
 
---
 
# Problem Statement
 
The problem statement for the ShopWise Assistant competition revolves around developing an AI-powered support assistant to enhance customer interactions on ShopWise Solutions, an e-commerce platform specializing in electronics and gadgets. The assistant must efficiently handle customer inquiries about products, such as descriptions, comparisons, availability, and recommendations, as well as manage order-related queries, including tracking, status updates, history, return eligibility, and shipping updates. It should seamlessly integrate with ShopWise’s databases to provide accurate, real-time responses while avoiding inaccuracies or fabricated information. The solution should support multi-turn conversations for handling complex queries and deliver personalized interactions based on customer data. Additionally, the assistant must ensure a smooth and fast user experience, with scalable and reliable deployment, aligning with ShopWise's goals of improving customer engagement and satisfaction.

![logo](https://github.com/Syam916/oreally_sql/blob/master/image%20(1).png)
 
 
The website for **ShopWise Solution** is a sleek and user-friendly e-commerce platform. It is designed to provide a seamless shopping experience with a modern interface. Key features include: 
 
1. **Header Navigation**: 
   - A prominently displayed header features the brand logo, a search bar for easy product discovery, and navigation links to key sections like "Home," "About," "Products," "My Account," and "Cart."
 
2. **Interactive Chatbot**: 
   - A chatbot icon in the bottom right corner provides real-time assistance, improving customer support and engagement by addressing queries or guiding users through the website.
 
---
 
# Context View

![architecture](https://github.com/Syam916/oreally_sql/blob/master/Data%20Flow%20Diagram%20Whiteboard%20in%20Dark%20Yellow%20Light%20Yellow%20Black%20Monochromatic%20Style%20(1)%20(3).png)
 
The workflow depicted in the image outlines the step-by-step process of how the ShopWise Chatbot operates. Here's the detailed description: 
 
1. **Start**: 
   - The process begins with initializing the workflow.
 
2. **Data Cleaning**: 
   - The chatbot's system preprocesses the input data using tools like Pandas to ensure the data is clean and structured properly.
 
3. **Prompt Input**: 
   - A user provides a prompt or query to the chatbot as input, which initiates the processing.
 
4. **LLM Model Processing**: 
   - The prompt is processed using a Gemini Pro LLM (Large Language Model) to analyze the query. This step involves determining whether the input prompt is valid and related to the existing data.
 
   - **If the prompt is valid and related**: 
     - The system converts the prompt into an SQL query for retrieving or manipulating database records.
   - **If the prompt is not related to the data**: 
     - The system identifies this mismatch and notifies the user that the given prompt does not align with the available data, prompting for revalidation or rephrasing.
 
5. **SQL Query Conversion**: 
   - Valid prompts are converted into SQL queries to fetch or process information from the database effectively.
 
6. **RAG Enhancement**: 
   - After retrieving the data, the system employs a RAG (Retrieval-Augmented Generation) mechanism to enhance the quality of the generated text response. This ensures the response is coherent, accurate, and relevant.
 
7. **Response Generation**: 
   - The enhanced response is provided to the user in a clear and understandable format.
 
8. **End**: 
   - The process concludes with the chatbot delivering the final response to the user.
 
This workflow ensures accuracy, relevance, and high-quality interaction, making the chatbot efficient for user queries.
 
---
 
# Architecture
 
The image depicts the AI-Powered Chatbot Architecture designed for a seamless user experience in a customer service system. Here’s the description of its components and workflow:
 
1. **User Interaction**:
   - The user starts by selecting a language.
   - The user enters a query, which is sent to the server for processing.
 
2. **Server and Chatbot**:
   - The server forwards the query to the chatbot system.
   - Inside the chatbot, several components work to process the query:
     - **Encode and Decode Data**: Prepares the input query for processing and decodes the output for a response.
     - **Tokenization**: Breaks the input into smaller meaningful units (tokens) for processing.
     - **Wordnet Model**: Utilizes a lexical database (such as WordNet) for understanding word meanings and relationships.
     - **Sentence Similarity Check**: Analyzes the similarity between user input and pre-existing data or knowledge base to provide the best match.

![architecture](https://github.com/Syam916/oreally_sql/blob/master/image%20(2).png)

3. **Database**:
   - The chatbot interacts with a database to fetch or store information needed for responding to queries or improving the system.
 
4. **Response Flow**:
   - After processing, the chatbot generates potential responses, which are passed to a **Response Selector**.
   - The **Response Selector** determines the final response to send back to the user.
 
5. **Feedback Loop**:
   - If the response is invalid or unsatisfactory, the user can send feedback to the system. This feedback is processed to enhance the chatbot's performance.
 
Overall, the diagram illustrates the end-to-end workflow of a chatbot system from user input to response delivery, including backend components like tokenization, similarity checks, and feedback integration. 
 
---
# Chatbot Functionalities

![architecture](https://github.com/Syam916/oreally_sql/blob/master/Blue%20and%20White%20Circle%20Organizational%20Chart.png)

The diagram represents the core functionalities of a chatbot and how they interact with each other. Each connection has a specific purpose, demonstrating the logical flow of how different features work together to deliver seamless customer service. Here's a detailed explanation: 

## 1. Natural Language Understanding (NLU)
**Logic:**  
The NLU functionality serves as the entry point for the chatbot. It processes user input (text or voice) and identifies the intent (e.g., product query, order tracking) and entities (e.g., product name, order ID).  

**Connections:**  
- **To Database Integration:**  
  Once the user query is understood, the chatbot determines if data needs to be fetched from databases (e.g., product or order details).   
- **To Multi-Turn Dialogue Management:**  
  If the query requires follow-up questions (e.g., "Which product are you referring to?"), NLU enables managing the context. 

---

## 2. Database Integration
**Logic:**  
This functionality interacts with the Product Database and Order Database to fetch real-time information, such as product specifications, prices, order status, and return eligibility.  

**Connections:**  
- **To Personalized Responses:**  
  The fetched data is passed to the response generator to craft personalized replies based on the user’s query.  
- **To NLU:**  
  If an error occurs (e.g., "Order not found"), it triggers NLU to handle error messages appropriately. 
 

---

## 3. Multi-Turn Dialogue Management
**Logic:**  
Handles conversations that require multiple exchanges, ensuring the chatbot maintains context and provides relevant answers.   

**Connections:**  
- **To Order and Return Management:**  
 If the conversation involves managing multiple steps (e.g., verifying eligibility for returns), the chatbot maintains the state and context.   
- **To NLU:**  
 Feedback from user responses is processed for the next step in the dialogue.  

---

## 4. Personalized Responses
**Logic:**  
Based on the user’s query and retrieved data, the chatbot generates a customized response tailored to the context and user preferences.  

**Connections:**  
- **To Voice Interaction:**  
  Converts text-based responses into speech for voice-based interactions.  
- **To Multilingual Support:**  
  Translates responses into the user’s preferred language for accessibility.  

---

## 5. Order and Return Management
**Logic:**  
Handles complex queries about orders, such as checking status, return eligibility, and refund details.  

**Connections:**  
- **To Multilingual Support:**  
  Provides return or order details in the customer’s preferred language.  
- **To Advanced Analytics:**  
  Logs interactions to identify trends like frequent return reasons or delayed orders.  

---

## 6. Voice Interaction
**Logic:**  
Converts user queries from speech to text and chatbot responses from text to speech, enabling hands-free interaction.  

**Connections:**  
- **To Personalized Responses:**  
  Uses text-based responses and converts them to speech output.  
- **To NLU:**  
  Sends processed text (converted from speech) to NLU for understanding and intent recognition.  

---

## 7. Multilingual Support 
**Logic:**  
Ensures users can interact with the chatbot in their preferred language, making it accessible to a global audience.   

**Connections:**  
- **To Personalized Responses:**  
  Translates chatbot responses into the user’s chosen language.  
- **To Advanced Analytics:**  
  Logs language preferences and usage patterns for strategic insights.  

---

## 8. Advanced Analytics
**Logic:**  
Captures and analyzes user interaction data for chatbot improvement and customer service strategies.  

**Connections:**  
- **To All Functionalities:**  
  Analyzes data from all functionalities, such as response accuracy, order trends, and multilingual usage.  
