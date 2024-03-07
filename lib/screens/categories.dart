import 'package:flutter/material.dart';

import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/category_grid_item.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  //with keyword is used to add functionality from another class into our own class
  //It merges a class into our behind the scenes

  late AnimationController
      _animationController; //late tells FLutter that this value won't be initialized right away, but
  //when it is used in the program, it will definitely have some value.
  //Animation Controllers cannot be initialized at the time of declaration, therefore we use
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync:
          this, //vsync controls the number of frames per second that an animation runs at. Setting it to this refers to this entire code
      duration: const Duration(milliseconds: 900),
      lowerBound: 0, //This is used as a reference in the builder argument.
      upperBound: 1,
    );

    _animationController.forward(); //This is used to start the animation.
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    ); // Navigator.push(context, route)
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          _animationController, //animation properties that we want to animate with are used here
      child: GridView(
        //child argument of Animated Builder are those widgets that aren't supposed to be animated.
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          // availableCategories.map((category) => CategoryGridItem(category: category)).toList()
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
        ],
      ),
      builder: (context, child) => SlideTransition(
        position: Tween(
          //Tween decides 'between' which two offsets you want to animate
          begin: const Offset(
              0.0, 0.5), //The position you wanna start the animation from
          end: const Offset(
              0.0, 0.0), //The position you wanna end the animation at
        ).animate(
          CurvedAnimation(
              parent: _animationController,
              curve: Curves
                  .decelerate), //Animation used is _animationController, with a decelerate style.
        ),
        child: child,
      ),
    );
  }
}


/*
Padding(
        .//builder's child argument is the content that will be animated, without changing its layout. Its included in the animation,
        .//but it isnt animated.
        padding: EdgeInsets.only(
          top: 500 - _animationController.value * 500,
        ),
        child:
            child, //The Padding is animated, but the child it contains is the child passed to builder i.r. GridView
      ),
*/

/* SlideTransition(
        position: _animationController.drive( //drive converts the lower and upper bound values to values that can be used by offfsets.
          Tween(
            begin: const Offset(
                0.0, 0.5), //The position you wanna start the animation from
            end: const Offset(
                0.0, 0.0), //The position you wanna end the animation at
          ),
        ),
        child: child,
      ),
 */