CREATE CONSTRAINT IF NOT EXISTS FOR (n: `Character`) REQUIRE (n.`name`) IS UNIQUE;


LOAD CSV WITH HEADERS FROM "characters.csv" AS nodeRecord
WITH *
WHERE NOT nodeRecord.`name` IN $idsToSkip AND NOT nodeRecord.`name` IS NULL
MERGE (n: `Character` { `name`: nodeRecord.`name` })
SET n.`height` = nodeRecord.`height`
SET n.`mass` = nodeRecord.`mass`
SET n.`hair_color` = nodeRecord.`hair_color`
SET n.`skin_color` = nodeRecord.`skin_color`
SET n.`eye_color` = nodeRecord.`eye_color`
SET n.`birth_year` = nodeRecord.`birth_year`
SET n.`gender` = nodeRecord.`gender`
SET n.`homeworld` = nodeRecord.`homeworld`
SET n.`species` = nodeRecord.`species`;

CREATE CONSTRAINT IF NOT EXISTS FOR (n: `Planet`) REQUIRE (n.`name`) IS UNIQUE;



LOAD CSV WITH HEADERS FROM "planets.csv" AS nodeRecord
WITH *
WHERE NOT nodeRecord.`name` IN $idsToSkip AND NOT nodeRecord.`name` IS NULL
MERGE (n: `Planet` { `name`: nodeRecord.`name` })
SET n.`rotation_period` = nodeRecord.`rotation_period`
SET n.`orbital_period` = nodeRecord.`orbital_period`
SET n.`diameter` = nodeRecord.`diameter`
SET n.`climate` = nodeRecord.`climate`
SET n.`gravity` = nodeRecord.`gravity`
SET n.`terrain` = nodeRecord.`terrain`
SET n.`surface_water` = nodeRecord.`surface_water`
SET n.`population` = nodeRecord.`population`;


CREATE CONSTRAINT IF NOT EXISTS FOR (n: `Species`) REQUIRE (n.`name`) IS UNIQUE;

LOAD CSV WITH HEADERS FROM "species.csv" AS nodeRecord
WITH *
WHERE NOT nodeRecord.`name` IN $idsToSkip AND NOT nodeRecord.`name` IS NULL
MERGE (n: `Species` { `name`: nodeRecord.`name` })
SET n.`classification` = nodeRecord.`classification`
SET n.`designation` = nodeRecord.`designation`
SET n.`average_height` = nodeRecord.`average_height`
SET n.`skin_colors` = nodeRecord.`skin_colors`
SET n.`hair_colors` = nodeRecord.`hair_colors`
SET n.`eye_colors` = nodeRecord.`eye_colors`
SET n.`average_lifespan` = nodeRecord.`average_lifespan`
SET n.`language` = nodeRecord.`language`
SET n.`homeworld` = nodeRecord.`homeworld`;

LOAD CSV WITH HEADERS FROM "characters.csv" AS relRecord
MATCH (source: `Character` { `name`: relRecord.`name` })
MATCH (target: `Planet` { `name`: relRecord.`homeworld` })
MERGE (source)-[r: `FROM`]->(target);

LOAD CSV WITH HEADERS FROM "characters.csv" AS relRecord
MATCH (source: `Character` { `name`: relRecord.`name` })
MATCH (target: `Species` { `name`: relRecord.`species` })
MERGE (source)-[r: `IDENTIFIES_AS`]->(target);

LOAD CSV WITH HEADERS FROM "species.csv" AS relRecord
MATCH (source: `Species` { `name`: relRecord.`name` })
MATCH (target: `Planet` { `name`: relRecord.`homeworld` })
MERGE (source)-[r: `ORIGINATED_FROM`]->(target);