import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_quiz/bloc/word_bloc.dart';
import 'package:mini_quiz/utils/app_color.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Guess the Word",
          style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocConsumer<WordBloc, WordState>(
          listener: (context, state) {
            if (state.words.isNotEmpty &&
                state.userWord.join() == state.words[0].word) {
              // Directly call showDialog without using Future.delayed
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Correct!"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("You guessed the word!"),
                        Text("Description: ${state.words[0].description}"),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.read<WordBloc>().add(NextWord());
                          Navigator.of(context).pop();
                        },
                        child: const Text("Next Word"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            if (state.completed) {
              return Center(
                child: Text(
                  "Congratulations! You've completed the game.",
                  style: GoogleFonts.lato(
                      fontSize: 24, color: AppColors.secondary),
                ),
              );
            }
            if (state.words.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.words.length,
                          itemBuilder: (context, index) {
                            return AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 500),
                              child: Hero(
                                tag: 'word-image-${state.words[index].image}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/image.jpg',
                                    image: state.words[index].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 60,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index < state.userWord.length) {
                              context
                                  .read<WordBloc>()
                                  .add(RemoveCharacter(index));
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                index < state.userWord.length
                                    ? state.userWord[index]
                                    : '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: state.userWord.length,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 60,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return InkWell(
                          onTap: () {
                            context.read<WordBloc>().add(
                                AddCharacter(state.shuffledLetters[index]));
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                state.shuffledLetters[index],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: state.shuffledLetters.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
