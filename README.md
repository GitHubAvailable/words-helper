#  WordsHelper

## Index
- [WordsHelper](#wordshelper)
  - [Index](#index)
  - [Description](#description)
    - [Words List](#words-list)
    - [Learning System](#learning-system)
  - [Features](#features)
  - [What's Next](#whats-next)
  - [Installation](#installation)

## Description
WordsHelper is an application based on swiftUI that allows users to create 
personalized words lists and memorize these words using the learning system. 

### Words List
A word list has the following attributes:
+ `language` - the language of the words within the words list, planned
to use for determining proper sorting method

In a words list, each word has the following fields:
+ `key` - the word (e.g., `Code`), which should be unique to enter the 
learning system
+ `notes` - a brief description of the meaning of the word (e.g., 
`Writing Code`)
+ `pronounciation` - the pronounciation of the word (e.g., [`[kohd]`][1])
+ `proficiency` - the user's familiarity with that word on a scale of 1 to 
5, with `1` representing never seen before, and `5` representing clearly 
understand its meaning and usage
+ `description` - a detailed description of the word (e.g., `Lorem ipsum ...`)

### Learning System
The learning system is divided to 6 stages:
1. Learn/review all words one by one.
2. Review unfamiliar words (`Proficiency` less than 3) one by one.
3. Multiple-Choice about unfamiliar words.
4. Learn/review all words one by one in detail.
5. Review all words in as list.
6. Multiple-Choice about unfamiliar words.

The following table shows the infomation of a word displayed in 
each stage

## Features
### Words List Editor
+ Create and Save words lists
+ Reorder words
+ Mark duplicated keys

## What's Next
- Learning System
- Localization
- + English

## Installation
The current version is built on iOS 15 or above.

### Setup
1. Download the repository.
2. Open the project in Xcode.

**Note:** This is my first project, and unexpected problems 
can happen. Feel free to open issues to report them.

## Contribution
Any suggestions and contributions are welcome! You can 
1. Report Bugs
2. Give suggestion
3. Contribute code


[1]: https://dictionary.cambridge.org/dictionary/english/code
