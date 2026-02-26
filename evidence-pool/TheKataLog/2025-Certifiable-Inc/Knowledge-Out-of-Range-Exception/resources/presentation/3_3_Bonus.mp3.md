# Transcript: 3_3_Bonus.mp3

There's one more important thing to add. As mentioned, LLM interaction yields nondeterministic results. That means it would be really hard to test the entire system behavior. Knowing that, we made sure that we can mock the AI components out since the interface between the prompt generator and the AI service is really simple. Text goes in, structured text goes out. For the purpose of testing, we can replace any or all AI services with fixed deterministic ones so that we have full control over key data that's going into the system. That way, we can go through the entire flow and fully control the data.

---
*Transcribed by Deepgram Nova-2 | Confidence: 0.9994*
