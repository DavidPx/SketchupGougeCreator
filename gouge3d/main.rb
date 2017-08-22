require 'sketchup.rb'
module Deciducraft
    module Gouge3D
        def self.create_model

            model = Sketchup.active_model

            model.start_operation('Create Gouge', true)

            group = model.active_entities.add_group
            entities = group.entities


            cubePoints = [
                Geom::Point3d.new(0,0,0),
                Geom::Point3d.new(4,0,0),
                Geom::Point3d.new(4,4,0),
                Geom::Point3d.new(0,4,0)
            ]

            cubeFace = entities.add_face(cubePoints)

            cubeFace.pushpull(-4)

            model.commit_operation
        end

        unless file_loaded?(__FILE__)
            puts "Creating menu.."
            menu = UI.menu('Plugins')

            menu.add_item("Create Gouge"){
                self.create_model
            }

            file_loaded(__FILE__)

        end
    end
end