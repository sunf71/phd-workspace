classdef Segment
    
    properties (SetAccess = private)
        len;
        indices;
        technique;
    end
    
    methods
        
        function[obj] = Segment(len, indices, technique)
            obj.len = len;
            obj.indices = indices;
            obj.technique = technique;
        end
               
        function[out] = get.len(obj)
            out = obj.len;
        end
        
        function[out] = get.indices(obj)
            out = obj.indices;
        end
        
        function[out] = get.technique(obj)
            out = obj.technique;
        end
        
        function [obj] = set.len(obj, len)
            obj.len = len;
        end
        
        function [obj] = set.indices(obj, indices)
            obj.indices = indices;
        end
        
        function [obj] = set.technique(obj, technique)
            obj.technique = technique;
        end
        
        function[out] = eq(obj,obj2) 
            if length(obj2) > 1
               throw(MException('Segment:eqMultiple','??? Cannot compare to multiple elements at once.'))
            end

            out = strcmp(class(obj),class(obj2)) && obj.len == obj2.len; % obj2 must be of the same class
        end
        
        function[out] = gt(obj,obj2) 
            if length(obj2) > 1
               throw(MException('Segment:gtMultiple','??? Cannot compare to multiple elements at once.'))
            end

            out = isa(obj2,'Segment') && obj.len > obj2.len; % obj2 must be a Segment
        end
        
    end
    
end
