import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/quiz/presentation/view_model.dart/quiz_bloc.dart';
import 'package:skin_muse/features/quiz/presentation/view_model.dart/quiz_event.dart';
import 'package:skin_muse/features/quiz/presentation/view_model.dart/quiz_state.dart';


class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizBloc()..add(QuizStarted()),
      child: const QuizView(),
    );
  }
}

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  List<Widget> buildStars(BuildContext context) {
    final random = Random();
    final starCount = 12;
    final size = MediaQuery.of(context).size;

    return List.generate(starCount, (index) {
      double left = random.nextDouble() * size.width;
      double top = random.nextDouble() * size.height * 0.8;
      double iconSize = 8 + random.nextDouble() * 8;

      return Positioned(
        left: left,
        top: top,
        child: Icon(
          Icons.star,
          size: iconSize,
          color: Colors.yellow[300],
          shadows: const [
            Shadow(color: Colors.white70, blurRadius: 6, offset: Offset(0, 0)),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final pinkGradientStart = const Color(0xFFFAD1E3);
    final pinkGradientEnd = const Color(0xFFFF65AA);
    final pinkSelectedColor = const Color(0xFFA55166);
    final lightPink = const Color(0xFFFAD1E3);

    final skinTypeDescriptions = {
      "Dry":
          "Your skin tends to feel tight, flaky, or rough. It needs deep hydration and gentle care.",
      "Oily":
          "Your skin often looks shiny or greasy. Focus on lightweight, oil-controlling products.",
      "Combination":
          "You have both oily and dry areas. Balanced care works best for you.",
      "Normal": "Your skin feels balanced and even. Gentle maintenance is key!",
      "Sensitive":
          "Your skin reacts easily to products or the environment. Use calming, hypoallergenic products.",
    };

    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        if (state.isFinished) {
          return Scaffold(
            backgroundColor: pinkGradientStart,
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        pinkGradientStart,
                        pinkGradientEnd.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                ...buildStars(context),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icon.png', height: 110),
                      const SizedBox(height: 40),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "\u2728 Your Skin Type is: ",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: pinkSelectedColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.result ?? "",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[300],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              skinTypeDescriptions[state.result] ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: pinkSelectedColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: pinkSelectedColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Product Recommendations",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final question = state.currentQuestion;

        return Scaffold(
          backgroundColor: pinkGradientStart,
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      pinkGradientStart,
                      pinkGradientEnd.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              ...buildStars(context),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/icon.png', height: 110),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: pinkSelectedColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          for (var option in question.options)
                            GestureDetector(
                              onTap:
                                  () => context.read<QuizBloc>().add(
                                    OptionSelected(option),
                                  ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      state.selectedOption == option
                                          ? lightPink
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    if (state.selectedOption == option)
                                      BoxShadow(
                                        color: lightPink.withOpacity(0.8),
                                        blurRadius: 12,
                                        offset: const Offset(0, 3),
                                      ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: pinkSelectedColor,
                                      fontWeight:
                                          state.selectedOption == option
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed:
                                    state.currentIndex == 0
                                        ? null
                                        : () => context.read<QuizBloc>().add(
                                          QuizBackPressed(),
                                        ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      state.currentIndex == 0
                                          ? Colors.grey[400]
                                          : Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                    color:
                                        state.currentIndex == 0
                                            ? Colors.grey[700]
                                            : pinkSelectedColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed:
                                    () => context.read<QuizBloc>().add(
                                      QuizNextPressed(),
                                    ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  state.currentIndex ==
                                          state.questions.length - 1
                                      ? "Finish"
                                      : "Next",
                                  style: TextStyle(
                                    color: pinkSelectedColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
