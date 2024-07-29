import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/word.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  WordBloc() : super(const WordState()) {
    on<LoadWords>(_onLoadWords);
    on<AddCharacter>(_onAddCharacter);
    on<RemoveCharacter>(_onRemoveCharacter);
    on<NextWord>(_onNextWord);
    on<ShuffleLetters>(_onShuffleLetters);

    add(LoadWords());
  }

  void _onLoadWords(LoadWords event, Emitter<WordState> emit) {
    List<Word> words = [
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/1.webp?v=1682812404",
          word: "musiqa"),
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/3.webp?v=1682812404",
          word: "shisha"),
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/5/37.webp?v=1682812404",
          word: "qum"),
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/5/53.webp?v=1682812404",
          word: "ko'k"),
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/5/66.webp?v=1682812404",
          word: "sovuq"),
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/57.webp?v=1682812404",
          word: "tutmoq"),
    ];

    emit(state.copyWith(words: words));
    add(ShuffleLetters());
  }

  void _onAddCharacter(AddCharacter event, Emitter<WordState> emit) {
    List<String> updatedUserWord = List.from(state.userWord)
      ..add(event.character);
    emit(state.copyWith(userWord: updatedUserWord));
  }

  void _onRemoveCharacter(RemoveCharacter event, Emitter<WordState> emit) {
    if (state.userWord.isNotEmpty && event.index < state.userWord.length) {
      List<String> updatedUserWord = List.from(state.userWord)
        ..removeAt(event.index);
      emit(state.copyWith(userWord: updatedUserWord));
    }
  }

  void _onNextWord(NextWord event, Emitter<WordState> emit) {
    if (state.words.isNotEmpty) {
      List<Word> updatedWords = List.from(state.words)..removeAt(0);
      emit(state.copyWith(
          words: updatedWords, userWord: [], completed: updatedWords.isEmpty));

      if (updatedWords.isNotEmpty) {
        add(ShuffleLetters());
      }
    }
  }

  void _onShuffleLetters(ShuffleLetters event, Emitter<WordState> emit) {
    if (state.words.isNotEmpty) {
      final word = state.words[0].word;
      List<String> letters = word.split('');
      if (letters.length < 12) {
        letters.addAll(List.generate(
          12 - letters.length,
          (_) => characters[Random().nextInt(characters.length)],
        ));
      }
      letters.shuffle();
      emit(state.copyWith(shuffledLetters: letters));
    }
  }
}

List<String> characters = [
  'a',
  'b',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'x',
  'y',
  'z',
  'ʻ',
  'ʼ',
  'ö',
  'ü'
];
