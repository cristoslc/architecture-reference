Interview with AI expert
---

Many thanks to our AI expert, Dario Röthlisberger [Linkedin](https://www.linkedin.com/in/dario-r%C3%B6thlisberger-87086345/) 
for taking the time to provide us with insights and context from the world of LLMs.
The documentation below is not word for word, but paraphrased and summarized.
It leads to many [assumptions and requirements](/Requirements/requirements-and-assumptions.md) in the AI context.

# Documentation

- What LLM solutions exist for enterprises?
  - What they know: Azure, Google Cloud, OpenAI
- Is specialized knowledge necessary?
  - The solution design requires specialized knowledge. You pay either for potentially expensive mistakes
  that are made along the way or for skilled and experienced professionals.
  - Prompt engineering on the other hand is a lot of trial error that can be learned by any motivated engineer, when respecting the
  principles of the design.
- How often do models/versions need to be updated and why?
  - Lifecycle of models. Due to intensive development, LLMs will be EOL quickly. (timeline of 1-2 years)
- What is the difference between context upload and training?
  - Training is called 'fine-tuning'. Train and Test set. 
  - Sets need to be large and well engineered.
- When can we expect deterministic behavior?
  - The so-called temperature setting introduces a level of randomness to the answers of an LLM.
  - Temperature setting can be minimized, also to 0. But if temperature is 0, 
  changes in the prompt may lead to more erratic changes in the result.
  - Any change to AI or the prompt has the potential to change the outcome. But clever prompt engineering can alleviate that.
- What are the costs?
  - Pay as you go, pay per token (scales with the amount of text in the prompt & also incoming token).
  They had a project with relatively big but text-based prompts, where 500'000 prompts resulted in a 500'000 USD bill.
  Token-rate limit applies.
  - PTU: Flatrate but token-rate limit applies. The cheapest of they have heard of was 60'000 / month.
  - How easy is it to predict the cost?
    - PTU pricing is very transparent. One number they have heard was 60'000 USD / month. But this may
    vary greatly across offerings.
    - Pay as you go pricing has transparent pricing. One needs to additionally know the prompt size as well as the 
    response size. With tools like [tiktoken](https://github.com/openai/tiktoken/blob/main/README.md), 
    the number of tokens per prompt and response can be counted and the 
    corresponding price estimated.
    The response may be hard to predict but can also be limited by instructions in the prompt.
- How can we test our AI?
  - Every change of prompt or model may lead to possible chaotic behavior
  - We need a large and good test set to test the new model + prompt
  - The more fine-tuned your model, the more fine-tuning is needed for the next test. Danger of overfitting.
  - Form of fine-tuning: Reinforcement learning --> Human control for matches
- Are you aware of special support or conditions for non-profit organizations?
  - No.
- How do APIs of AI Models look like (synchronous vs asynchronous vs long-running)
  - REST, may take a long time. Delay can sometimes be 60s
  - Streaming, non-blocking, is possible. 
  - If rate-limit is reached, the stream stops. Leads to failure.
  - Live token-prediction needs to be done to avoid reaching the rate-limit.
- Trend: Will it become better, cheaper?
  - Trend is cheaper and cheaper. Context caching (currently available at Google) also allows for new possibilities to optimize.
  - Traffic control and therefore rate-limit optimization always helps to reduce cost.
- For using LLMs, do we need one of these external services or is there another way?
  - You can use Opensource models, Meta, Mistral. Sometimes very specific hardware is required. 
  - Can be deployed as cloud services, but it does not lead to a reduced cost compared to external.
  - To get it cheaper, you need it on-prem, but then pay for maintenance-cost yourself.
- Data privacy
  - Due to regulatory reasons, Azure, for example, stores prompts.
  - You can make an agreement with them, that they stop saving it. Then they only process the data. 
  But this comes at the cost that you now need to fulfill the regulatory requirements instead of Azure.
  I don't know anything else about US regulations and whether data privacy might be an issue.
- What formats can be entered?
  - Multimodale Models: Text, Audio, Images, PDF -> Image.
  - The conversion of media to tokens is less transparent than text. You will probably pay a premium.
  - Our use-case probably required to first use a OCR to extract text.
  But an OCR can not do everything, for example the visual representation of skills may vary a lot. 
  Probably both, ACR and text needs to be fed.

Other statements:
- The infrastructure cost of an external LLM will very likely be the main driver of the overall infrastructural cost.
- Hackers may include prompt-instruction in their resume for malicious reasons.
Resume preprocessing to avoid such 'prompt injection' will be needed.
