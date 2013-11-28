class ShoppingController < ApplicationController
  before_filter :authenticate_user!
  def index

    # copied over from the original app. Probably could use a refactor.
    # Okay, definitely could use a refactor.

  @children = Child.all
    @girlarray = Array.new
    @boyarray = Array.new
    @girltotal = 0
    @boytotal = 0
    for child in @children
      if child.gender == 'Boy'
        if child.age_type == 'year'
          @boyarray[child.age] != nil ?  @boyarray[child.age] += 1 : @boyarray[child.age] = 1
        else
          @boyarray[0] != nil ? @boyarray[0] += 1: @boyarray[0] = 1
        end
        @boytotal += 1
      else
        if child.age_type == 'year'
          @girlarray[child.age] != nil ? @girlarray[child.age] += 1 : @girlarray[child.age] = 1
        else
          @girlarray[0] != nil ? @girlarray[0] += 1 : @girlarray[0] = 1
        end
        @girltotal += 1
      end
    
      
      if @boyarray.size >= @girlarray.size
        @colsize = @boyarray.size
      else
        @colsize = @girlarray.size
      end
      
      #Now, let's loop through each and normalize them.
      #We'll use the largest and find all the nil values.
      
     for i in 0..@colsize-1
        if @boyarray[i] == nil
          @boyarray[i] = 0
        end
       if @girlarray[i] == nil
          @girlarray[i] = 0
       end
      end
    end

  end
end
