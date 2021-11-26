global.dunder = new Dunder();


db = global.dunder.init(DunderIndexedDatabase);
db.add_index_numeric("level")

db.set("a", {level: 1})
db.set("b", {level: 2})
db.set("c", {level: 3})
db.set("d", {level: 1})
db.set("e", {level: 2})
db.set("f", {level: 3})

var _results = db.find({level: 2})

show_message(_results);