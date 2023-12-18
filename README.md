This is a simple Behavior Tree system for Gamemaker Studio 2!
Behavior trees are kind of like Finite State Machines, but allow you to have fallback states and is organized more sequentially.

To get started all you need to do is create a reference to the behavior tree like so:
```
behavior = bh_tree();
```

From there you can add conditions, sequences, selectors and much more! The `bh_tree()` itself contains 3 way to add to it via:
- `.add(node_tree)`
- `.selector(node_tree)`
- `.sequence(node_tree)`

`.selector()` and `.sequence()` just automatically `.add()` a `bh_selector` or `bh_sequence` to your behavior tree, but you are free to
use them independantly with the `.add()` command as well if you prefer.
There are 4 main types of behavior nodes you can use:
-  `bh_selector()`   | This will let you add multiple fallback states that can be 'selected' from if one fails
-  `bh_sequence()`   | This lets you ensure that a sequence of succesful sub-node events occur, and if one fails, will return a fail for the entire branch of nodes
-  `bh_condition()`  | This can be used to run a function that returns a `true` or `false`. If `true` is returned from the input function, the behavior was successful and will continue the chain, otherwise it will fail.
-  `bh_action()`     | This is just a simple call command that will only execute if the conditions, sequences, or selectors before it have not failed!

So for instance if you wanted to make a simple **Patrol - Chase - Attack** enemy AI behavior tree you would want to set it up like so:
**CREATE EVENT**
```
behavior = bh_tree();
bh_tree.selector(
  bh_sequence(
    bh_condition(checkEnemyNearby),
    bh_action(chaseEnemy)
  ),
  bh_sequence(
    bh_condition(enemyInAttackRange),
    bh_action(attackEnemy)
  ),
  bh_action(patrolForEnemies)
);
```

**STEP EVENT**
```
behavior.step();
```
And thats it! You can easily get some basic AI behavior working with only this code (as seen here):
https://github.com/Gizmo199/BehaviorTree/assets/25496262/5f3af526-3b7e-443a-8b34-37cfcf0cecd7

