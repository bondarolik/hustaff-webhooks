Organization.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!(:organizations)
ActiveRecord::Base.connection.reset_pk_sequence!(:projects)
ActiveRecord::Base.connection.reset_pk_sequence!(:tasks)

organization = Organization.create(name: "Hubstaff")
project      = organization.projects.create(name: "Webhooks App")
projects.tasks.create(name: "Add Token based authorization", description: "Some cool words about this task")
projects.tasks.create(name: "Write tests for new functionality", description: "Some cool words about this task")
projects.tasks.create(name: "Fix issues reported by Rubocop", description: "Some cool words about this task")
projects.tasks.create(name: "Publish branch to a repository on Github", description: "Some cool words about this task")