# Scroll to Specific Word in TextField - Flutter Example
Flutter package make you able to enter a target text then from user then search for this text in another TextField widget and scroll to this text

# Why did I create this code 

There was a question on StackoverFlow about *How can I scroll to a substring in a TextField* 
the Question and My answer link : https://stackoverflow.com/a/79423594/23598383
This Flutter project demonstrates how to scroll to a specific word inside a TextField programmatically. It uses a combination of TextEditingController, ScrollController, and TextPainter to achieve precise scrolling to a target word.

Features:
- Scroll to a specific word inside a multi-line TextField.

- Move the cursor to the start of the target word.

- Dynamic calculation of scroll offset using TextPainter.

# Use Cases:
- Highlighting and scrolling to specific text in a large input field.

- Building custom text search functionality within a TextField.

# How It Works:
- The user enters text into a multi-line TextField.

- When a button is pressed, the app searches for a specific word (e.g., 'specific') in the text.

- Using TextPainter, the app calculates the scroll offset for the word.

- The ScrollController scrolls the TextField to the word's position, and the cursor is moved to the start of the word.
