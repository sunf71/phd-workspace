classdef PQueue < Queue
   
   % PQueue - strongly-typed Priority Queue collection
   %
   % Properties:
   %
   %   Type (string)
   %   Comparator (function handle, @gt by default) 
   %   
   % Methods:
   %
   %   PQueue(type)
   %   PQueue(type,comparator) 
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
   % Compatible classes must overload eq() for object-to-object comparisons
   % 
   % Comparator must be defined in the class, or a base class: RedWidget and 
   % BlueWidget objects can be combined if a Widget comparator is defined
   %
   % Derived from Queue
   %
   % Example:
   %
   % q = PQueue('Widget',@gt)   
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
   
   properties (SetAccess = protected)
       Comparator  % function handle
   end
         
   methods 
       
       function[obj] = PQueue(type,varargin)
           obj = obj@Queue(type);
           if nargin > 1
               obj.Comparator = varargin{1};
           else
               obj.Comparator = @gt;
           end
       end
      
       function[obj] = offer(obj,e)
           
           if length(e) > 1
              throw(MException('PQueue:offerMultiple','??? Cannot offer multiple elements at once.'))
           end   
           if ~isa(e,obj.Type)
              throw(MException('PQueue:offerInvalidType','??? Invalid type.'))
           end
           
           obj.Elements{obj.lastInd+1} = e;
           obj.lastInd = obj.lastInd + 1;
           if(length(obj.Elements) == obj.lastInd)
               obj.Elements = [obj.Elements obj.Elements];
           end
           
           currInd = obj.lastInd;
           parentInd = floor(currInd / 2);
           while(parentInd ~= 0)
               if(obj.Comparator(obj.Elements{currInd},obj.Elements{parentInd}))
                   tempElement = obj.Elements{currInd};
                   obj.Elements{currInd} = obj.Elements{parentInd};
                   obj.Elements{parentInd} = tempElement;
                   
                   currInd = parentInd;
                   parentInd = floor(currInd / 2);
               else
                   break;
               end
           end
       end
       
       function[out] = poll(obj)
           
           if obj.isempty
               out = [];
               return;
           end
           
           out = obj.Elements{1};

           if(obj.size == 1)
               obj.lastInd = obj.lastInd - 1;
               return;
           end
           
           obj.Elements{1} = obj.Elements{obj.lastInd};
           obj.lastInd = obj.lastInd - 1;
           
           currInd = 1;
           childInd = currInd * 2;
           
           while(childInd <= obj.lastInd)
               
               if(childInd + 1 > obj.lastInd)

                   if(~obj.Comparator(obj.Elements{currInd},obj.Elements{childInd}))
                   
                       tempElement = obj.Elements{currInd};
                       obj.Elements{currInd} = obj.Elements{childInd};
                       obj.Elements{childInd} = tempElement;

                       currInd = childInd;
                       childInd = currInd * 2;
                   else
                       break;
                   end

               elseif(obj.Comparator(obj.Elements{childInd + 1},obj.Elements{childInd}))
                   
                   if(~obj.Comparator(obj.Elements{currInd},obj.Elements{childInd + 1}))
                   
                       tempElement = obj.Elements{currInd};
                       obj.Elements{currInd} = obj.Elements{childInd + 1};
                       obj.Elements{childInd + 1} = tempElement;

                       currInd = childInd + 1;
                       childInd = currInd * 2;
                   else
                       break;
                   end
                   
               elseif(~obj.Comparator(obj.Elements{currInd},obj.Elements{childInd}))
                   
                   tempElement = obj.Elements{currInd};
                   obj.Elements{currInd} = obj.Elements{childInd};
                   obj.Elements{childInd} = tempElement;
                   
                   currInd = childInd;
                   childInd = currInd * 2;
                   
               else
                   break;
               end
           end
       end
                  
   end   
    
end
