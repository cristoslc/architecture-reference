Existing Certification Testing Architecture (Test 1: Aptitude Test)
              Used to register candidates for certification, and
                                                                            This service is used by the expert architects to retrieve
              includes candidate profile information.
                                                                            ungraded short answer questions from the candidate
                                                                            and allows the expert to assign a grade as well as
                                                                            detailed feedback for each question.

                                                                            This service also acts as the main orchestrator to
                                                                            update the candidates certification status and also notify
              Primary service for administering aptitude tests. This        the candidate of the results.
              service loads tests, delivers question to the user
              interface, captures candidate answers, and forwards
              thise answers to the appropriate queue for processing
              as it receives them. Also times the test, and keeps track     Maintains the overall status of the candidates progress,
              of where each candidate is in the certification test in the   including if they passed test 1 (aptitude), passed test 2
              event of a restart or recovery situation.                     (architecture solution), and during test 2 the time that
                                                                            has elasped since passing test 1 and retrieving the case
                                                                            study. Candidates have 30 days after passing test 1 to
                                                                            start test 2, and 2 weeks to complete test 2.


              This service receives short answers from the queue and
                                                                            Notifies the candidate of their grade for test 1 (aptitude
              persists them in an ungraded answer database for later
                                                                            test) and also includes feedback on short answer
              grading.
                                                                            questions from the expert if the answer was incorrect.

                                                                            If the candidate passed test 1, the email also includes
                                                                            instructions for downloading the case study and starting
                                                                            test 2.
              Receives multiple choice questions from a queue and
              automatically grades the answer based on the answer
              key in the test database.
