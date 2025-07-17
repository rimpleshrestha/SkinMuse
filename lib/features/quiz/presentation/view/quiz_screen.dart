import 'dart:math';

import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      "question":
          "How does your skin usually feel a few hours after washing it?",
      "options": [
        "Tight or rough",
        "Shiny or greasy",
        "Shiny in T-zone, dry on cheeks",
        "Comfortable and balanced",
        "Itchy, red, or easily irritated",
      ],
    },
    {
      "question": "How often does your skin feel oily?",
      "options": ["Rarely", "Sometimes", "Often", "Almost always"],
    },
    {
      "question": "How does your skin react to the sun?",
      "options": [
        "Burns easily",
        "Tans gradually",
        "Rarely burns or tans",
        "Not sure",
      ],
    },
    {
      "question": "How sensitive is your skin to skincare products?",
      "options": [
        "Very sensitive, reacts easily",
        "Somewhat sensitive",
        "Not sensitive at all",
        "Unsure",
      ],
    },
    {
      "question": "How would you describe your skin's overall texture?",
      "options": [
        "Rough or flaky",
        "Oily and smooth",
        "Combination (varies by area)",
        "Soft and even",
        "Red or irritated",
      ],
    },
  ];

  final Map<String, String> skinTypeDescriptions = {
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

  int currentQuestionIndex = 0;
  String? selectedOption;
  List<String> answers = [];
  String? skinType;

  final int starCount = 12;
  final Random random = Random();

  List<Widget> buildStars() {
    return List.generate(starCount, (index) {
      double left = random.nextDouble() * MediaQuery.of(context).size.width;
      double top =
          random.nextDouble() * MediaQuery.of(context).size.height * 0.8;
      double size = 8 + random.nextDouble() * 8;

      return Positioned(
        left: left,
        top: top,
        child: Icon(
          Icons.star,
          size: size,
          color: Colors.yellow[300],
          shadows: const [
            Shadow(color: Colors.white70, blurRadius: 6, offset: Offset(0, 0)),
          ],
        ),
      );
    });
  }

  void handleOptionSelect(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  String calculateSkinType(List<String> answers) {
    Map<String, int> score = {
      "Dry": 0,
      "Oily": 0,
      "Combination": 0,
      "Normal": 0,
      "Sensitive": 0,
    };

    for (var answer in answers) {
      if (answer.contains("Tight") ||
          answer.contains("Rough") ||
          answer == "Rarely" ||
          answer == "Rough or flaky") {
        score["Dry"] = score["Dry"]! + 1;
      }
      if (answer.contains("greasy") ||
          answer == "Often" ||
          answer == "Almost always" ||
          answer == "Oily and smooth") {
        score["Oily"] = score["Oily"]! + 1;
      }
      if (answer.contains("T-zone") ||
          answer == "Sometimes" ||
          answer == "Combination (varies by area)") {
        score["Combination"] = score["Combination"]! + 1;
      }
      if (answer.contains("balanced") ||
          answer == "Tans gradually" ||
          answer == "Not sensitive at all" ||
          answer == "Soft and even" ||
          answer == "Rarely burns or tans") {
        score["Normal"] = score["Normal"]! + 1;
      }
      if (answer.contains("irritated") ||
          answer.contains("sensitive") ||
          answer == "Burns easily" ||
          answer == "Red or irritated") {
        score["Sensitive"] = score["Sensitive"]! + 1;
      }
    }

    var sorted =
        score.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  void onNext() {
    if (selectedOption == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select an answer!")));
      return;
    }

    answers.add(selectedOption!);

    if (currentQuestionIndex == questions.length - 1) {
      final result = calculateSkinType(answers);
      setState(() {
        skinType = result;
      });
    } else {
      setState(() {
        currentQuestionIndex++;
        selectedOption = null;
      });
    }
  }

  void onBack() {
    if (currentQuestionIndex == 0) return;
    setState(() {
      currentQuestionIndex--;
      answers.removeLast();
      selectedOption = null;
      skinType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final pinkGradientStart = const Color(0xFFFAD1E3);
    final pinkGradientEnd = const Color(0xFFFF65AA);
    final pinkSelectedColor = const Color(0xFFA55166);
    final lightPink = const Color(0xFFFAD1E3);

    if (skinType != null) {
      return Scaffold(
        backgroundColor: pinkGradientStart,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [pinkGradientStart, pinkGradientEnd.withOpacity(0.1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            ...buildStars(),
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
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                          "💫 Your Skin Type is: ",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: pinkSelectedColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          skinType!,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[300],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          skinTypeDescriptions[skinType!] ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: pinkSelectedColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to product recommendations screen here
                          },
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

    return Scaffold(
      backgroundColor: pinkGradientStart,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [pinkGradientStart, pinkGradientEnd.withOpacity(0.1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ...buildStars(),
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
                        question["question"],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      for (var option in question["options"])
                        GestureDetector(
                          onTap: () => handleOptionSelect(option),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color:
                                  selectedOption == option
                                      ? lightPink
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                if (selectedOption == option)
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
                                      selectedOption == option
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
                                currentQuestionIndex == 0 ? null : onBack,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  currentQuestionIndex == 0
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
                                    currentQuestionIndex == 0
                                        ? Colors.grey[700]
                                        : pinkSelectedColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: onNext,
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
                              currentQuestionIndex == questions.length - 1
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
  }
}
