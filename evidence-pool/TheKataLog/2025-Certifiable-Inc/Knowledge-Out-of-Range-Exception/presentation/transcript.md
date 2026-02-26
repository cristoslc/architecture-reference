# Video Presentation Transcript (slides prepared with Prezi here: https://prezi.com/p/edit/mggyhciusnxz/)

## [PW] 1. Introduction

Hello everyone!
We call ourselves KnowledgeOutOfRangeException and today we'd like to show you our humble proposition for how to improve the grading system with AI-assisted solutions. Without any further ado... Let's crack on!

[Name of the team in big font and round avatars of our faces]

## [PW] 2. Let's start with "why"

Let's start with "why"! Nowadays, AI is everywhere - literally everywhere. All companies claim to be introducing it just for the sake of advertising with this magic key word: "AI". So let's look into our current system, business needs and market estimations to see what we want to achieve. 

[Funny illustration of AI being everywhere]

### Demand
The company plans to expand to new markets, which will generate up to 10 times more certification applications than we currently process. On top of that, the market is expected to grow by 21% in the next 4 years. It means that in 2029 we'll face up to 2400 candidates per week. Without any changes to our process, we'll need around 25,000 work-hours of our experts per week.

[Demand sheet and charts]

### Throughput
Let's see if it's doable. Currently, our contractors work around 8 hours per week. To meet such high demand, we would need to increase headcount by 200%. Alternatively, we could switch to full-time employment, but still, we would need to extend to 500 employees. Not only is it very costly, it's probably impossible, as there are not enough experts out there.

[Throughput sheet and charts]

## [KS] 3. Introducing AI

Ok, now we know. If we don't act now, we'll soon drown in applications. We need to ask machines for help to speed things up. Let's take a look at how, or where exactly, AI assistance can be added.

[Funny illustration of asking AI to help us]

### App graph update
We decided to include AI-assisted grading in both tests. Here's how it looks now:
- Multiple choice questions are unambiguous, so we left them as is.
- For the short answer responses, we've added an AI Grading component that takes over the manual grading process.
- The AI Grading component uses multiple AI models and prompts to evaluate test responses.
- The results from different AI models are aggregated to provide a final grading suggestion.
- Human experts still play a role by reviewing and adjusting the AI-generated grades if necessary.

[Updated graphs of the new solution structure, with new elements clearly marked]

## [KS] 4. Time is crucial, but it's not everything

To keep up with the market, we must provide results faster, but it can't be just ANY result. We still need to make sure the assessment is fair and accurate. That's how we intend to achieve it.

### Confidence level
First of all, we want to extend the prompt, so that the AI answer includes confidence level on top of the response assessment itself. This will allow us to disregard potentially inaccurate assessments, as well as emphasize the ones that are considered certain. 

[Thresholds for confidence level] 

### Multiple models, multiple prompts
Secondly, since AI processing is not deterministic, we call for a bit of statistics to help us. We propose to run each question assessment multiple times, varying both AI model and the prompt. Some prompt strategies may prove more efficient with a given question than others. This way, we can limit the errors to a minimum, by crossing out extremes and extracting averages.

### Human approval
And finally, we want AI to provide its feedback, but still want a human expert to approve it. Our system will present the full set of AI assessments, and leave it for the employee to quickly scan through them to either confirm or reject the result, question by question. 

## [AJ] 5. Let's take a step further

Ok, we took care of the core functionality in our system. We saved a lot of time for our experts. It's great, but it's not the only work we do every day. So, since we have the technology there, why not take a step further, and use the same mechanism for continuous improvement and automated issue monitoring?

### Prompt accuracy monitoring
No matter how much we try to prepare efficient and diverse prompts, they will never be perfect. We're only humans after all. Keeping track of confidence levels for each prompt and model will allow us to identify the ones that often give inaccurate responses, flagging them for improvement.

### Pass-rate analysis
It's not only the assessment that might be going wrong. It might also be the question itself. We can use AI to keep an eye on how well candidates are doing over time. By analyzing pass rates, we can spot patterns and figure out which questions might be too hard or too easy. This helps us tweak the tests to make sure they're fair and balanced for everyone.

### Cross-check for test updates
Let's try to think ahead. As the world changes - requirements too, and our tests will most likely need updates at some point. Whenever we update test questions, we can use AI to double-check them for clarity and accuracy. This way, we catch any potential issues early on, ensuring that the questions are well-formed and unambiguous before they go live.

## [AJ] 6. Conclusion
It doesn't have to end here. There's no such thing as a perfect product. But let's not jump ahead of ourselves. We first need to see this part through.
Thank you for hearing us out. See you on the road!

[Graphics for "sky is the limit"]