require 'sketchup.rb'
# todo: change these to require
load File.join(__dir__, 'parameters.rb')
load File.join(__dir__, 'gouge.rb')
module Deciducraft
    module Gouge3D
        def self.create_model

            parameters = Parameters.new

            if (parameters.cancelled)
                return
            end

            model = Sketchup.active_model

            gouge = Gouge.new
            gouge.addToModel(model, parameters)

            model.commit_operation
        end

        self.create_model # todo: remove this

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