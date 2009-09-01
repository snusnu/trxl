require "#{File.dirname(__FILE__)}/../spec_helper"

describe "The Trxl::StdLib" do

  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should be able to parse the whole Trxl::StdLib code" do
    lambda { parse(Trxl::Calculator.stdlib) }.should_not raise_error
  end
  
  it "should define a foreach function with read access to the outer env" do
    program = <<-PROGRAM
      require 'stdlib/foreach_in';
      foreach_in(1..3, fun(c) { c });
    PROGRAM
    eval(program).should == 3
  end
  
  it "should define a foreach function with write access to the outer env" do
    program = <<-PROGRAM
      require 'stdlib/foreach_in';
      sum = 0;
      a = 1..10;
      foreach_in(a, fun(e) { 
        sum = sum + e 
      });
      sum;
    PROGRAM
    eval(program).should == 55
  end

  it "should define an inject function with read access to the outer env" do
    program = <<-PROGRAM
      require 'stdlib/inject';
      inject(0, 1..6, fun(memo, val) { memo + val });
    PROGRAM
    eval(program).should == 21
  end

  it "should define an inject function with write access to the outer env" do
    program = <<-PROGRAM
      require 'stdlib/inject';
      ratio = fun(values) {
        base = 0;
        positives = inject(0, values, fun(memo, val) {
          if(ENV[val] == "yes")
            base = base + 1; 
            memo + 1
          elsif(ENV[val] == "no") 
            base = base + 1; 
            memo
          else 
            memo
          end
        });
        if(base > 0)
          ROUND((ROUND(positives, 10) / base) * 100, 2)
        else
          0
        end        
      };
      ratio('a'..'c');
    PROGRAM
    eval(program, { :a => 'yes', :b => 'no', :c => 'n/a' }).should == 50
  end

  it "should define a map function with read access to the outer env" do
    program = <<-PROGRAM
      require 'stdlib/map';
      map([[1,2],[3,4],[5,6]], fun(a) { a[1]; });
    PROGRAM
    eval(program).should == [2,4,6]
  end

  it "should define a map function with write access to the outer env" do
    program = <<-PROGRAM
      require 'stdlib/map';
      a = [];
      map([[1,2],[3,4],[5,6]], fun(x) { a << x[1]; });
      a;
    PROGRAM
    eval(program).should == [2,4,6]

    program = <<-PROGRAM
      require 'stdlib/map';
      sum = 0;
      map([[1,2],[3,4],[5,6]], fun(x) { sum = sum + x[1]; });
      sum;
    PROGRAM
    eval(program).should == 12
  end

  it "should define a 'select' function for any enumerable collection" do
    program = <<-PROGRAM
      require 'stdlib/select';
      select([ 1, 2, 3, 4 ], fun(e) { e % 2 == 0 });
    PROGRAM
    eval(program).should == [ 2, 4 ]

    program = <<-PROGRAM
      require 'stdlib/select';
      select(1..4, fun(e) { e % 2 == 0 });
    PROGRAM
    eval(program).should == [ 2, 4 ]
  end

  it "should define a 'reject' function for any enumerable collection" do
    program = <<-PROGRAM
      require 'stdlib/reject';
      reject([ 1, 2, 3, 4 ], fun(e) { e % 2 == 0 });
    PROGRAM
    eval(program).should == [ 1, 3 ]

    program = <<-PROGRAM
      require 'stdlib/reject';
      reject(1..4, fun(e) { e % 2 == 0 });
    PROGRAM
    eval(program).should == [ 1, 3 ]
  end

  it "should define a 'ratio' function for any enumerable collection" do
    env = {
      :a => "Ja", 
      :b => "Ja",
      :c => "Ja",
      :d => "Ja"
    }
    req_stmt = "require 'stdlib/ratio';"
    eval("#{req_stmt} ratio('a'..'d', 'Ja', 'keine Angabe');", env).should == 100
    
    env = {
      :a => "Ja", 
      :b => "Ja",
      :c => "Nein",
      :d => "Nein"
    }
    req_stmt = "require 'stdlib/ratio';"
    eval("#{req_stmt} ratio('a'..'d', 'Ja', 'keine Angabe');", env).should == 50
    
    env = {
      :a => "Nein", 
      :b => "Nein",
      :c => "Nein",
      :d => "Nein"
    }
    req_stmt = "require 'stdlib/ratio';"
    eval("#{req_stmt} ratio('a'..'d', 'Ja', 'keine Angabe');", env).should == 0
    
    env = {
      :a => "Ja", 
      :b => "Nein",
      :c => "Nein",
      :d => "Nein",
      :e => "keine Angabe"
    }
    req_stmt = "require 'stdlib/ratio';"
    eval("#{req_stmt} ratio('a'..'e', 'Ja', 'keine Angabe');", env).should == 25
    
    env = {
      :a => "keine Angabe"
    }
    req_stmt = "require 'stdlib/ratio';"
    eval("#{req_stmt} ratio(['a'], 'Ja', 'keine Angabe');", env).should be_nil
    
    env = {
      :a => "keine Angabe",
      :b => "keine Angabe",
      :c => "keine Angabe"
    }
    req_stmt = "require 'stdlib/ratio';"
    eval("#{req_stmt} ratio('a'..'c', 'Ja', 'keine Angabe');", env).should be_nil
    
    env = {
      :a => "Ja",
      :b => "keine Angabe"
    }
    req_stmt = "require 'stdlib/ratio';"
    eval("#{req_stmt} ratio('a'..'b', 'Ja', 'keine Angabe');", env).should == 100
    
    env = {
      :a => "Nein",
      :b => "keine Angabe"
    }
    req_stmt = "require 'stdlib/ratio';"
    eval("#{req_stmt} ratio('a'..'b', 'Ja', 'keine Angabe');", env).should == 0
  end

  it "should define a 'in_groups_of' function for any enumerable collection" do
    program = <<-PROGRAM
      require 'stdlib/in_groups_of';
      in_groups_of(2, [ 1, 2, 3, 4 ], fun(group) { group });
    PROGRAM
    eval(program).should == [ [ 1, 2 ], [ 3, 4 ] ]

    program = <<-PROGRAM
      require 'stdlib/in_groups_of';
      in_groups_of(2, 1..4, fun(group) { group });
    PROGRAM
    eval(program).should == [ [ 1, 2 ], [ 3, 4 ] ]

    program = <<-PROGRAM
      require 'stdlib/inject';
      require 'stdlib/in_groups_of';
      in_groups_of(2, 1..4, fun(group) { SUM(group) });
    PROGRAM
    eval(program).should == [ 3, 7 ]
    
    program = <<-PROGRAM
      require 'stdlib/in_groups_of';
      in_groups_of(2, 'a'..'d', fun(group) { group });
    PROGRAM
    eval(program).should == [ [ 'a', 'b' ], [ 'c', 'd' ] ]
    
    env = Trxl::Environment.new({
      :a => { 
        1 => "Building 1", 
        2 => "Building 2", 
        3 => "Building 3" 
      },
      :b => { 
        1 => "Feuerwehrgebäude",
        2 => "Schulgebäude",
        3 => "Wohngebäude"
      },
      :c => { 1 => 100, 2 => 200, 3 => 300 },
      :d => { 1 => 100, 2 => 200, 3 => 300 },
      :e => { 1 => 100, 2 => 200, 3 => 300 },
      :f => { 1 => 100, 2 => 200, 3 => 300 },
      :g => { 1 => 100, 2 => 200, 3 => 300 },
      :h => { 1 => 100, 2 => 200, 3 => 300 },
      :i => { 1 => 100, 2 => 200, 3 => 300 },
      :j => { 1 => 100, 2 => 200, 3 => 300 },
      :k => { 1 => 100, 2 => 200, 3 => 300 },
      :l => { 1 => 100, 2 => 200, 3 => 300 },
      :m => { 1 => 100, 2 => 200, 3 => 300 },
      :n => { 1 => 100, 2 => 200, 3 => 300 },
      :o => { 1 => 100, 2 => 200, 3 => 300 },
      :p => { 1 => 100, 2 => 200, 3 => 300 },
      :q => { 1 => 100, 2 => 200, 3 => 300 },
      :r => { 1 => 100, 2 => 200, 3 => 300 },
      :s => { 1 => 100, 2 => 200, 3 => 300 },
      :t => { 1 => 100, 2 => 200, 3 => 300 },
      :u => { 
        1 => [ 15, 15, 15 ],
        1 => [ 20, 20, 20 ],
        1 => [ 30, 30, 30 ]
      }
    })
  end
  
  it "should allow recursive functions as accumulator in 'in_groups_of' function calls" do
    program = <<-PROGRAM
      require 'stdlib/inject';
      require 'stdlib/in_groups_of';
      in_groups_of(2, 1..4, fun(group) {
        inject(0, group, fun(sum, e) {
          sum + e
        });
      });
    PROGRAM
    eval(program).should == [ 3, 7 ]
  end
  
  it "should define a 'sum_of_type' function" do
    env = {
      :types => {
        1 => "Feuerwehrgebäude", 
        2 => "Schulgebäude", 
        3 => "Sonstige",
      },
      :values => { 
        1 => [ 100, 100, 100 ],
        2 => [ 200, 200, 200 ],
        3 => [ 300, 300, 300 ]
      }
    }
    req_stmt = "require 'stdlib/sum_of_type';"
    eval("#{req_stmt} sum_of_type('Feuerwehrgebäude', types, values);", env).should == 300
    eval("#{req_stmt} sum_of_type('Schulgebäude', types, values);", env).should == 600
    eval("#{req_stmt} sum_of_type('Sonstige', types, values);", env).should == 900
  end
  
  it "should define a 'avg_sum_of_type' function" do
    env = {
      :types => {
        1 => "Feuerwehrgebäude", 
        2 => "Schulgebäude", 
        3 => "Sonstige",
      },
      :values => { 
        1 => [ 100, 100, 100 ],
        2 => [ 200, 200, 200 ],
        3 => [ 300, 300, 300 ]
      }
    }
    req_stmt = "require 'stdlib/avg_sum_of_type';"
    eval("#{req_stmt} avg_sum_of_type('Feuerwehrgebäude', types, values);", env).should == 100
    eval("#{req_stmt} avg_sum_of_type('Schulgebäude', types, values);", env).should == 200
    eval("#{req_stmt} avg_sum_of_type('Sonstige', types, values);", env).should == 300
  end
  
  it "should define a 'total_range_sum_of_type' function" do
    env = {
      :types => {
        1 => "Feuerwehrgebäude", 
        2 => "Schulgebäude", 
        3 => "Sonstige",
      },
      :a => { 
        1 => [ 100, 100, 100 ],
        2 => [ 200, 200, 200 ],
        3 => [ 300, 300, 300 ]
      },
      :b => { 
        1 => [ 100, 100, 100 ],
        2 => [ 200, 200, 200 ],
        3 => [ 300, 300, 300 ]
      }
    }
    req_stmt = "require 'stdlib/total_range_sum_of_type';"
    eval("#{req_stmt} total_range_sum_of_type('Feuerwehrgebäude', types, 'a'..'b');", env).should == 600
    eval("#{req_stmt} total_range_sum_of_type('Schulgebäude', types, 'a'..'b');", env).should == 1200
    eval("#{req_stmt} total_range_sum_of_type('Sonstige', types, 'a'..'b');", env).should == 1800
  end
  
  it "should define a 'avg_range_sum_of_type' function" do
    env = {
      :types => {
        1 => "Feuerwehrgebäude", 
        2 => "Schulgebäude", 
        3 => "Sonstige",
      },
      :a => { 
        1 => [ 100, 100, 100 ],
        2 => [ 200, 200, 200 ],
        3 => [ 300, 300, 300 ]
      },
      :b => { 
        1 => [ 100, 100, 100 ],
        2 => [ 200, 200, 200 ],
        3 => [ 300, 300, 300 ]
      }
    }
    req_stmt = "require 'stdlib/avg_range_sum_of_type';"
    eval("#{req_stmt} avg_range_sum_of_type('Feuerwehrgebäude', types, 'a'..'b');", env).should == 200
    eval("#{req_stmt} avg_range_sum_of_type('Schulgebäude', types, 'a'..'b');", env).should == 400
    eval("#{req_stmt} avg_range_sum_of_type('Sonstige', types, 'a'..'b');", env).should == 600
  end
  
  it "should define a 'year_from_date' function" do
    req_stmt = "require 'stdlib/year_from_date';"
    eval("#{req_stmt} year_from_date('01/1999');").should == 1999
    eval("#{req_stmt} year_from_date('12/1999');").should == 1999
    eval("#{req_stmt} year_from_date('12/2008');").should == 2008
    eval("#{req_stmt} year_from_date('12/2008');").should == 2008
  end
  
  it "should define a 'month_from_date' function" do
    req_stmt = "require 'stdlib/month_from_date';"
    eval("#{req_stmt} month_from_date('01/1999');").should == 1
    eval("#{req_stmt} month_from_date('12/1999');").should == 12
    eval("#{req_stmt} month_from_date('1/2008');").should == 1
    eval("#{req_stmt} month_from_date('12/2008');").should == 12
  end
  
end
