Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

migration

friendship : foreign_key:true { to_table user }

m F
belongs_to friend, class_name: "User"

U
has_m frships
has_m friends through fships
