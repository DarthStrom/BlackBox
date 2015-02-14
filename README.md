# Black Box

## Overview
- One player hides balls, the other tries to find them
- Four balls are hidden on an 8x8 grid by the hider
- The seeker uses imaginary rays to get information on where the balls are hidden
- The computer is the hider in the 1-player game
- Players take a turn at each role in the 2-player game
- The object is to find the hidden balls in as few tries as possible

## Rays

<pre>
  32 31 30 29 28 27 26 25
 ╔══╤══╤══╤══╤══╤══╤══╤══╗
1║  │  │  │  │  │  │  │  ║24
 ╟──┼──┼──┼──┼──┼──┼──┼──╢
2║  │  │  │  │  │  │  │  ║23
 ╟──┼──┼──┼──┼──┼──┼──┼──╢
3║  │  │  │  │  │  │  │  ║22
 ╟──┼──┼──┼──┼──┼──┼──┼──╢
4║  │  │  │  │  │  │  │  ║21
 ╟──┼──┼──┼──┼──┼──┼──┼──╢
5║  │  │  │  │  │  │  │  ║20
 ╟──┼──┼──┼──┼──┼──┼──┼──╢
6║  │  │  │  │  │  │  │  ║19
 ╟──┼──┼──┼──┼──┼──┼──┼──╢
7║  │  │  │  │  │  │  │  ║18
 ╟──┼──┼──┼──┼──┼──┼──┼──╢
8║  │  │  │  │  │  │  │  ║17
 ╚══╧══╧══╧══╧══╧══╧══╧══╝
   9 10 11 12 13 14 15 16
</pre>

- Entry points are numbered 1 to 32 starting on the uppermost left and going counter-clockwise
- Rays can:
    - Stay in the box (Hit)
    - Exit back out the way they came (Reflection)
    - Exit somewhere else (Detour)
- The hider traces the ray's movement and responds with the result

## Ray Movement
Hit: The ray travels into a ball

<pre>
──────O
</pre>

Detour: Rays change direction (90 degrees) to avoid passing by a ball

<pre>
    O
───┐
   │
</pre>

Reflection: The ray comes back out the way it came. This can happen by being deflected before it enters

<pre>
   ║O
 ─┐║
   ║
</pre>

It can also happen by being deflected by two balls at once

<pre>
      O
──────
      O
</pre>

## Marks
When a ball exits the box, it is marked

- A hit is marked with red on its entry point
- A reflection is marked with yellow on its entry point
- A detour is marked with matching orange symbols on the entry point and the exit point

## Special cases
If a ray encounters one ball straight on and one to the side, it counts as a hit

<pre>
──────O
      O
</pre>

If a ray encounters three balls, it counts as a hit

<pre>
      O
──────O
      O
</pre>

## Multiple detours
A ray can be detoured many times... this can be misleading for the seeker

<pre>
      O
─────┐
     │
  O  │
   ┌─┘
   │  O
</pre>

## Gameplay
1. The hider marks the locations of the hidden balls
2. The seeker looks for hidden balls by sending in rays from different entry points
3. The seeker marks balls as they are found
4. Marked balls may be moved if further clues indicate that the placement may not be correct
5. When the seeker is finished guessing, the game is scored
    a. 1 point for each ray used
    b. 5 points for each incorrect ball

## Winning
When both players have played then the player with the lowest score is the winner

In the case of a single player game, the score is compared with a predetermined "par" score for the given ball placement

[<img src="https://i.creativecommons.org/l/by-sa/4.0/80x15.png">](http://creativecommons.org/licenses/by-sa/4.0/ "license")

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/ "license").