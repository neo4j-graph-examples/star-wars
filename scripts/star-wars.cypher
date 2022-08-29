// :param url=>"https://vbatushkov.bitbucket.io/swapi.json"
:param url=>"https://raw.githubusercontent.com/neo4j-graph-examples/star-wars/main/import/swapi.json"

create constraint on (f:Film) assert f.url is unique;
create constraint on (c:Character) assert c.url is unique;
create constraint on (p:Planet) assert p.url is unique;
create constraint on (s:Starship) assert s.url is unique;
create constraint on (v:Vehicle) assert v.url is unique;
create constraint on (s:Species) assert s.url is unique;

// todo remove arrays / relationships from data that's set
CALL apoc.load.json($url) YIELD value
FOREACH (film in value.films | MERGE (f:Film { url: film.url }) ON CREATE SET f += film {.*, characters:null, planets:null, species:null,starships:null, vehicles:null})
FOREACH (character in value.people | MERGE (c:Character { url: character.url }) ON CREATE SET c += character {.*, species:null, vehicles:null, starships:null, films:null, homeworld:null} )
FOREACH (planet in value.planets | MERGE (p:Planet { url: planet.url }) ON CREATE SET p += planet {.*, residents:null, films:null} )
FOREACH (spec in value.species | MERGE (s:Species { url: spec.url }) ON CREATE SET s += spec {.*, films:null, people:null, homeworld:null})
FOREACH (vehicle in value.vehicles | MERGE (v:Vehicle { url: vehicle.url }) ON CREATE SET v += vehicle {.*, pilots:null, films:null} )
FOREACH (starship in value.starships | MERGE (s:Starship { url: starship.url }) ON CREATE SET s += starship {.*, pilots:null, films:null} )
;


CALL apoc.load.json($url) YIELD value
UNWIND value.films as film
UNWIND film.characters as character_url
MATCH (f:Film { url: film.url })
MATCH (c:Character { url: character_url })
MERGE (c)-[:APPEARED_IN]->(f);


CALL apoc.load.json($url) YIELD value
UNWIND value.films as film
UNWIND film.planets as planet_url
MATCH (f:Film { url: film.url })
MATCH (p:Planet { url: planet_url })
MERGE (p)-[:APPEARED_IN]->(f);

CALL apoc.load.json($url) YIELD value
UNWIND value.films as film
UNWIND film.species as species_url
MATCH (f:Film { url: film.url })
MATCH (spec:Species { url: species_url })
MERGE (spec)-[:APPEARED_IN]->(f);

CALL apoc.load.json($url) YIELD value
UNWIND value.films as film
UNWIND film.starships as starship_url
MATCH (f:Film { url: film.url })
MATCH (s:Starship { url: starship_url })
MERGE (s)-[:APPEARED_IN]->(f);

CALL apoc.load.json($url) YIELD value
UNWIND value.films as film
UNWIND film.vehicles as vehicle_url
MATCH (f:Film { url: film.url })
MATCH (v:Vehicle { url: vehicle_url })
MERGE (v)-[:APPEARED_IN]->(f);



CALL apoc.load.json($url) YIELD value
UNWIND value.people as character
UNWIND character.species as species_url
MATCH (c:Character { url: character.url })
MATCH (spec:Species { url: species_url })
MERGE (c)-[:OF]->(spec);

CALL apoc.load.json($url) YIELD value
UNWIND value.people as character
MATCH (c:Character { url: character.url })
MATCH (p:Planet { url: character.homeworld })
MERGE (c)-[:HOMEWORLD]->(p);

CALL apoc.load.json($url) YIELD value
UNWIND value.people as character
UNWIND character.vehicles as vehicle_url
MATCH (c:Character { url: character.url })
MATCH (v:Vehicle { url: vehicle_url })
MERGE (c)-[:PILOT]->(v);


CALL apoc.load.json($url) YIELD value
UNWIND value.people as character
UNWIND character.starships as starship_url
MATCH (c:Character { url: character.url })
MATCH (s:Starship { url: starship_url })
MERGE (c)-[:PILOT]->(s);


CALL apoc.load.json($url) YIELD value
UNWIND value.species as species
MATCH (spec:Species { url: species.url })
MATCH (p:Planet { url: species.homeworld })
MERGE (spec)-[:HOMEWORLD]->(p);