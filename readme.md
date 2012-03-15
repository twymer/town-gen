Town Generator
==============

About
-----

A class project to (quickly) procedurally generate towns for a Rogue-like or RPG type game.

It is done in Processing so that the world can be shown as it is built. This greatly slows down the actual generation process but is interesting to watch and very helpful for debugging.

The technique used is agent based, modeled after the technique discussed in [this paper](http://ccl.northwestern.edu/papers/ProceduralCityMod.pdf) by Thomas Lechner et al. Currently there are three agents implemented. An extender agent (who seeks unserviced territory and adds new roads), a connector agent (who connects the longer extension roads together) and a builder agent (who follows roads and places buildings).

Known issues and needed improvements
------------------------------------

The timespan for the projet was short so there are a lot of rough edges.

* Connector and Building Agents
    - Connector and building agents have trouble moving around the road system because they do so randomly.

* Extender Agents
    - Extender agents can waste time exploring area they definitely won't be able to build on because they simply move around the map using a drunken walk algorithm.
    - Their only restriction is they must stay within a certain area of any existing buildings.

* Connector Agents
    - Currently will find connections through buildings.
    - Need logic regarding road density and intersections.

* Building Agents
    - Their dimensions should be checked to prevent a building of size 1x6 pixels from being added.
    - The drawn buildings are constrained to aligning with diagonal roads (which is 95% of roads in my current implementation).
    - Gaps occur inside the buildings due to the way they are grown, this causes issues with roads being able to be built through them or buildings being able to overlap without any actual collisions occuring.
    - Currently since all buildings are the same color I didn't allow buildings to be built touching, but this should definitely be made possible.

Running the application
-----------------------

Processing is available on most platforms at [processing.org](http://processing.org/).

Open town_gen.pde in Processing and hit run.

Controls
--------

* E - Toggle world growth agents on/off.
* P - Turn on print view, disables all agents.
