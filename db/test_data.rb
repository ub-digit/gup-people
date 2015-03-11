require_relative "../config/environment"

def create_user(first_name, last_name, year_of_birth, affiliated, alternative_names, identifiers)
  person = Person.where(
    first_name: first_name,
    last_name: last_name,
    year_of_birth: year_of_birth,
    affiliated: affiliated
  ).first_or_create
  
  alternative_names.each do |alternative_name|
    AlternativeName.where(
      first_name: alternative_name[:first_name],
      last_name: alternative_name[:last_name],
      person_id: person.id
    ).first_or_create
  end
  identifiers.each do |identifier|
    Identifier.where(
      person_id: person.id,
      source_id: identifier[:source_id],
      value: identifier[:value]
    ).first_or_create
  end
end

create_user(
  'Johan', 
  'Andersson von Geijer', 
  '1970', 
  false, 
  [
    {first_name: 'Lars Johan', last_name: 'Andersson'}, 
    {first_name: 'Johan', last_name: 'von Geijer'}, 
    {first_name: 'Johan', last_name: 'Geijer'}, 
    {first_name: 'L J', last_name: 'A von Geijer'}
  ], 
  [
    {source_id: Source.find_by_name('xkonto'), value: 'xanjoo'},
    {source_id: Source.find_by_name('orcid'), value: 'orcid.org/0000-0003-0460-6600'}
  ])


create_user(
  'Niclas', 
  'Magnusson', 
  '1971', 
  true, 
  [], 
  [
    {source_id: Source.find_by_name('xkonto'), value: 'xmagnn'},
    {source_id: Source.find_by_name('orcid'), value: 'orcid.org/0000-0002-1843-2667'}
  ])

