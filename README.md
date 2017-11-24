# FillMeUp
Getting Boored? FillMeUp comes to the rescue. FillMeUp is a word game, which checks your sentence completion ability. You have fill meaningful words from the option and you get a score for every correct answer.

## Game Instructions
1. On opening the app, App fetches the content.
2. On top, there is replay button to reset the game and play again.
3. In every row, there is a word hidden, which is underlined and blue colored marked with 'x'.
4. Tap on cell, to revel options. Choosing an option will replace the selected option in Question.
5. After pressing submit, if each answer is correct, then level is increased, and so does the difficulty.
6. If one or more answers are incorrect, a Dialog is shown. You can here see the results where you went wrong.
7. On Choosing "Result option", a result screen will show the summary of your current level, and also the correct answers.
8. Enjoy :)

## Screenshots

Game Play             |  Game Dialog          |  Game Results         | Game Screen 
:-------------------------:|:-------------------------:|:-------------------------:| :-------------------------:
![alt text](https://user-images.githubusercontent.com/22045797/33210715-531b4564-d141-11e7-810c-9ac075e6132b.png) | ![alt text](https://user-images.githubusercontent.com/22045797/33210688-37c53c52-d141-11e7-8be6-0870d0a5cae4.png) | ![alt text](https://user-images.githubusercontent.com/22045797/33210684-339c4c06-d141-11e7-9862-952210ae9ee9.png) | ![alt text](https://user-images.githubusercontent.com/22045797/33210703-4763d704-d141-11e7-8ecf-dcb70bf057a2.png)

## Game Logic
1. The game difficulty is managed by choosing the word or tag for tokens. More difficult the  word removed, more difficult would be to guess.
2. So a sentence like "An apple is Sweet" would be tokenized on the lexical analysis of the sentence which would be [Determiner(An), Noun(Apple), is(Verb), Sweet(Adjectice)]. ,]
2. The game difficulty is Categorized into different Lexical Categories like "Prepositions", " Determiners","Verbs", "Nouns", "Pronouns", "Conjunctions" (Preposition is choosed as easiest, Conjunction is most difficult).
3. According to the User's Level, the tags are choosed , which will decide which word to be removed.
4. If tag matching to the difficulty is not found in the sentences, then tag with lower difficulty is searched until a suitable tag is found or the easiest level is Reached.
5. In case, no suitable tag is found, then the first avaible tag in the sentence is used.
6. After choosing the tag, corresponding Token is hidden. and would serve as the question for the user. The range of hidden text is saved for processing later.
7. The hidden word is replaced by Attributed String (Underline, Blue color) for identifying the location of hidden Text.
8. All the words hidden are used the options for filling in to the user.
9. As the user chooses a word, the choosen word is replaced in place of hidden word and changes are reflected.
10. After submission , if all answers are correct , then user's difficulty is increased.
11. A Cumulative score is scored which is the total correct since the start of the game.

## Things to mention
1. The URL is hard coded, so every time Content is same, but the options will  change as the user progresses in the game. This could not be made dymanic because every page has a pageid when is appended in Query for making request.
2. Tapping on cell opens Picker, originally i thought of inserting UITextfield in the string at the range of missing word.
3. Some words are missing in between the word, the  Missing word is present as a substring for a word in the sentence.

### Third Party Libraries Used
1. SwiftyJson : For serialization of json 
2.NVActivityIndicator : For Showing activity loader when network request is hit
3.Chameleon : This is used for Only flat colors.
4. PopUpDialog : Custom Popup handling

#### Tools Used
Swift Version : 3.2
Xcode 9

