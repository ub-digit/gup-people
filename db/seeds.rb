# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Source.where(
    id: 1,
    name: 'xkonto'
).first_or_create

Source.where(
    id: 2,
    name: 'orcid'
).first_or_create

Person.where(
    id: 1,
    first_name: 'Johan',
    last_name: 'Andersson von Geijer',
    year_of_birth: '1970',
    affiliated: false
).first_or_create

Person.where(
    id: 2,
    first_name: 'Niclas',
    last_name: 'Magnusson',
    year_of_birth: '1971',
    affiliated: true
).first_or_create

AlternativeName.where(
    id: 1,
    first_name: 'Lars Johan',
    last_name: 'Andersson',
    person_id: 1
).first_or_create

AlternativeName.where(
    id: 2,
    first_name: 'Johan',
    last_name: 'von Geijer',
    person_id: 1
).first_or_create

AlternativeName.where(
    id: 3,
    first_name: 'Johan',
    last_name: 'Geijer',
    person_id: 1
).first_or_create

AlternativeName.where(
    id: 4,
    first_name: 'L J',
    last_name: 'A von Geijer',
    person_id: 1
).first_or_create

Identifier.where(
    id: 1,
    person_id: 2,
    source_id: 1,
    value: 'xmagnn'
).first_or_create

Identifier.where(
    id: 2,
    person_id: 2,
    source_id: 2,
    value: 'orcid.org/0000-0002-1843-2667'
).first_or_create

Identifier.where(
    id: 3,
    person_id: 1,
    source_id: 1,
    value: 'xanjoo'
).first_or_create

Identifier.where(
    id: 4,
    person_id: 1,
    source_id: 2,
    value: 'orcid.org/0000-0003-0460-6600'
).first_or_create
