# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def add_items(items,coll)
  items.each {|item| coll.collection_highlight_items << CollectionHighlightItem.create(item_id:"#{item}")}
end

CollectionHighlight.find(:all).each {|h| h.destroy}
CollectionHighlightItem.find(:all).each {|hi| hi.destroy}

c1=CollectionHighlight.create(
  sort_order:1,
  name_en:'Laura Bassi\'s awards and medals',
  name_it:'Diplomi di Accademie e medaglia di Laura Bassi',
  description_en:'',
  description_it:'',
  image_url:'bv-sample.png')
c2=CollectionHighlight.create(
  sort_order:2,
  name_en:'Documents dealing with Laura Bassi\'s graduation',
  name_it:'Documenti relativi alla laurea di Laura Bassi',
  description_en:'',
  description_it:'',
  image_url:'bv-sample-2.png')
c3=CollectionHighlight.create(
  sort_order:3,
  name_en:'Poems in honour of Laura Bassi',
  name_it:'Poesie in elogio di Laura Bassi',
  description_en:'',
  description_it:'',
  image_url:'bv-sample-3.png')
c4=CollectionHighlight.create(
  sort_order:4,
  name_en:'About Laura Bassi',
  name_it:'di Laura Bassi',
  description_en:'',
  description_it:'',
  image_url:'bv-sample-3.png')
c5=CollectionHighlight.create(
  sort_order:5,
  name_en:'Documents concerning Veratti family',
  name_it:'Documenti relativi alla famiglia Veratti',
  description_en:'',
  description_it:'',
  image_url:'bv-sample-3.png')

c1_items=%w{ref444 ref436 ref440 ref442 ref446 ref450 ref461 ref464}
c2_items=%w{ref417 ref596 ref589 ref419 ref423}
c3_items=%w{ref593 ref586 ref486 ref494 ref510 ref492 ref512 ref547 ref537}
c4_items=%w{ref599 ref375 ref471 ref613 ref609}
c5_items=%w{ref272 ref169 ref174 ref216 ref246 ref305 ref329 ref335 ref730 ref736}

add_items(c1_items,c1)
add_items(c2_items,c2)
add_items(c3_items,c3)
add_items(c4_items,c4)
add_items(c5_items,c5)
