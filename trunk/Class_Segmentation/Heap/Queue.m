classdef Queue < handle
   
   % Queue - strongly-typed Queue collection
   %
   % Properties:
   %
   %   Type (string)
   %
   % Methods:
   %
   %   Queue(type)
   %   display
   %   size
   %   isempty
   %   clear
   %   contains(obj)
   %   offer(obj)
   %   remove(obj)
   %   peek   - returns [] if queue is empty
   %   poll   - returns [] if queue is empty
   %   values - returns contents in a cell array
   %
   % Notes:
   %
   % Compatible classes must overload eq() for object-to-object comparisons.
   %
   % Example:
   %
   % q = Queue('Widget')   
   %
   % q.offer(RedWidget(1))
   % q.offer(RedWidget(3))
   % q.offer(RedWidget(2))
   % q.offer(BlueWidget(2))
   % q.offer(BlueWidget(2))
   %
   % q.size
   % q.remove(RedWidget(2));
   % q.size
   % q.remove(BlueWidget(2));
   % q.size
   %
   % q.peek
   % q.poll
   % q.size
   %
   % Author: dimitri.shvorob@gmail.com, 3/15/09 
   % Modified for heap implementation and pre-allocation by:
   % a.mounir86@gmail.com, 24/06/2010
   
   properties (GetAccess = protected, SetAccess = protected, Hidden = true)
       Elements
       lastInd
   end
   
   properties (SetAccess = protected)
       Type
   end
         
   methods 
       
       function[obj] = Queue(type)
           if ~ischar(type)
              throw(MException('Queue:constructorInvalidType','??? ''type'' must be a valid class name.'))
           end   
           obj.Elements = cell(1, 100);
           obj.lastInd = 0;
           obj.Type = type;
       end
       
       function disp(obj)
           disp([class(obj) '<' obj.Type '> (head on top)'])
           if ~obj.isempty
              for i = 1:obj.lastInd
                  disp(obj.Elements{i})
              end   
           else
              disp([])
           end
       end
              
       function[out] = size(obj)
           out = obj.lastInd;
       end
       
       function[out] = values(obj)
           out = obj.Elements{1:obj.lastInd};
       end
              
       function[out] = isempty(obj)
           out = obj.size == 0;
       end
       
       function[obj] = clear(obj)
           obj.Elements = {};
           obj.lastInd = 0;
       end
       
       function[out] = contains(obj,e)
           out = false;
           for i = 1:obj.size
               if e == obj.Elements{i}
                  out = true;
                  break
               end
           end           
       end
       
       function[obj] = offer(obj,e)
           if length(e) > 1
              throw(MException('Queue:offerMultiple','??? Cannot offer multiple elements at once.'))
           end   
           if ~isa(e,obj.Type)
              throw(MException('Queue:offerInvalidType','??? Invalid type.'))
           end
           if isempty(obj.Elements)
              obj.Elements = {e};
           else
              obj.Elements{obj.lastInd+1} = e;
              obj.lastInd = obj.lastInd + 1;
              if(length(obj.Elements) == obj.lastInd)
                  obj.Elements = [obj.Elements obj.Elements];
              end
              
           end
       end   
       
       function[obj] = remove(obj,e)
           if length(e) > 1
              throw(MException('Queue:removeMultiple','??? Cannot remove multiple elements at once.'))
           end 
           if ~isa(e,obj.Type)
              throw(MException('Queue:removeInvalidType','??? Invalid type.'))
           end
           if ~isempty(obj.Elements)
              k = [];
              for i = 1:obj.size
                  if e == obj.Elements{i}
                     k = [k i];  %#ok
                  end
              end
              if ~isempty(k)
                  obj.Elements(k) = [];
                  obj.lastInd = obj.lastInd - length(k);
              end
           end
       end
       
       function[out] = peek(obj)
           if ~obj.isempty
               out = obj.Elements{1};
           else
               out = [];
           end    
       end
       
       function[out] = poll(obj)
           if ~obj.isempty
               out = obj.Elements{1};
               obj.Elements(1) = [];
               obj.lastInd = obj.lastInd - 1;
           else
               out = [];
           end    
       end
           
   end   
    
end
