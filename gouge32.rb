require 'sketchup.rb'
require 'extensions.rb'

module Deciducraft
    module Gouge3D

        unless file_loaded?(__FILE__)

            puts "Gouge3D Extension is loading..."

            ex = SketchupExtension.new('Gouge 3D', 'D:\github\Gouge3D\gouge3d\main')

            ex.description = 'Tormek Gouge Jig Simulator'
            ex.version = '0.0.1'
            ex.copyright = 'Deciducraft 2017'
            ex.creator = 'David Peters'

            Sketchup.register_extension(ex, true)

            file_loaded(__FILE__)
        end
    end
end
