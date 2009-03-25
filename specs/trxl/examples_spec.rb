require "#{File.dirname(__FILE__)}/../spec_helper"

describe "The CommunalAudit library" do

  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should include 'technical_operating_hours'" do
    req_stmt = "require 'stdlib/tech_op_hours';"
    eval("#{req_stmt} technical_operating_hours('Kleinbus (Van etc.)')").should             ==  428.57
    eval("#{req_stmt} technical_operating_hours('Pritschenwagen')").should                  ==  342.86
    eval("#{req_stmt} technical_operating_hours('PKW')").should                             ==  428.57
    eval("#{req_stmt} technical_operating_hours('LKW')").should                             ==  444.44
    eval("#{req_stmt} technical_operating_hours('Omnibus')").should                         ==  400.0
    eval("#{req_stmt} technical_operating_hours('Radlader (z.B. Volvo L90D)')").should      == 1250.0
    eval("#{req_stmt} technical_operating_hours('Traktor groß (z.B. Steyr 8075)')").should  ==  833.33
    eval("#{req_stmt} technical_operating_hours('Traktor klein (KUBOTA etc.)')").should     ==  900.0
    eval("#{req_stmt} technical_operating_hours('Unimog')").should                          == 1000.0
    eval("#{req_stmt} technical_operating_hours('Zugmaschine (z.B. Holder C9.88)')").should == 1667.67
    eval("#{req_stmt} technical_operating_hours('Kehrmaschine')").should                    ==  200.0
    eval("#{req_stmt} technical_operating_hours('Schneefräse')").should                     ==  350.0
    eval("#{req_stmt} technical_operating_hours('Streuwagen')").should                      ==  120.0
    eval("#{req_stmt} technical_operating_hours('Hanswurst')").should                       ==  0
  end
  
  it "should include 'life_expectancy'" do
    req_stmt = "require 'stdlib/life_expectancy';"
    eval("#{req_stmt} life_expectancy('Kleinbus (Van etc.)')").should             ==  7.0
    eval("#{req_stmt} life_expectancy('Pritschenwagen')").should                  ==  7.0
    eval("#{req_stmt} life_expectancy('PKW')").should                             ==  7.0
    eval("#{req_stmt} life_expectancy('LKW')").should                             ==  9.0
    eval("#{req_stmt} life_expectancy('Omnibus')").should                         ==  9.0
    eval("#{req_stmt} life_expectancy('Radlader (z.B. Volvo L90D)')").should      == 12.0
    eval("#{req_stmt} life_expectancy('Traktor groß (z.B. Steyr 8075)')").should  == 12.0
    eval("#{req_stmt} life_expectancy('Traktor klein (KUBOTA etc.)')").should     == 10.0
    eval("#{req_stmt} life_expectancy('Unimog')").should                          == 12.0
    eval("#{req_stmt} life_expectancy('Zugmaschine (z.B. Holder C9.88)')").should == 12.0
    eval("#{req_stmt} life_expectancy('Kehrmaschine')").should                    == 10.0
    eval("#{req_stmt} life_expectancy('Schneefräse')").should                     == 10.0
    eval("#{req_stmt} life_expectancy('Streuwagen')").should                      == 10.0
    eval("#{req_stmt} life_expectancy('Hanswurst')").should                       ==  0.0
  end


  it "should include 'amortization'" do
    program = <<-PROGRAM
      require 'stdlib/amortization';
      amortization(vehicle_type, acquisition_year, acquisition_cost);
    PROGRAM
    env = { 
      :vehicle_type => "PKW", 
      :acquisition_year => "01/2004", 
      :acquisition_cost => 21000.0,
      :TIME_LINE_ROOT => 2007
    }
    eval(program, env).should be_close(3000, 0.01)

    env = { 
      :vehicle_type => "PKW", 
      :acquisition_year => "01/2000", 
      :acquisition_cost => 21000.0,
      :TIME_LINE_ROOT => 2006
    }
    eval(program, env).should be_close(3000, 0.01)

    env = { 
      :vehicle_type => "PKW", 
      :acquisition_year => "01/1999", 
      :acquisition_cost => 21000.0,
      :TIME_LINE_ROOT => 2007
    }
    eval(program, env).should == 0

    env = { 
      :vehicle_type => "LKW", 
      :acquisition_year => "01/1999", 
      :acquisition_cost => 27000.0,
      :TIME_LINE_ROOT => 2007
    }
    eval(program, env).should be_close(3000, 0.01)
    

    env = { 
      :vehicle_type => "PKW", 
      :acquisition_year => "07/2000", 
      :acquisition_cost => 21000.0,
      :TIME_LINE_ROOT => 2007
    }
    eval(program, env).should be_close(1500, 0.01)
  end

  it "should include 'total_amortization'" do
    program = <<-PROGRAM
      require 'stdlib/total_amortization';
      total_amortization(types, years, costs);
    PROGRAM
    env = { 
      :TIME_LINE_ROOT => 2007,
      :types => { 1 => "PKW", 2 => "PKW" }, 
      :years => { 1 => "01/2004", 2 => "01/2005" }, 
      :costs => { 1 => 21000.0, 2 => 14000.0 },
    }
    eval(program, env).should be_close(5000, 0.01)

    env = { 
      :TIME_LINE_ROOT => 2007,
      :types => { 1 => "PKW", 2 => "LKW" }, 
      :years => { 1 => "01/2004", 2 => "01/2005" }, 
      :costs => { 1 => 28000.0, 2 => 27000.0 },
    }
    eval(program, env).should be_close(7000, 0.01)

    env = { 
      :TIME_LINE_ROOT => 2007,
      :types => { 1 => "PKW", 2 => "LKW" }, 
      :years => { 1 => "01/1999", 2 => "01/1999" }, 
      :costs => { 1 => 28000.0, 2 => 27000.0 },
    }
    eval(program, env).should be_close(3000, 0.01)
      
    env = {
      
      :TIME_LINE_ROOT => 2003,
      
      :types => { 
        1=>"Kleinbus (Van etc.)",              #  7
        2=>"Pritschenwagen",                   #  7
        3=>"PKW",                              #  7
        4=>"LKW",                              #  9
        5=>"Omnibus",                          #  9
        6=>"Radlader (z.B. Volvo L90D)",       # 12
        7=>"Traktor groß (z.B. Steyr 8075)",   # 12
        8=>"Traktor klein (KUBOTA etc.)",      # 10
        9=>"Unimog",                           # 12
        10=>"Zugmaschine (z.B. Holder C9.88)", # 12
        11=>"Kehrmaschine",                    # 10
        12=>"Schneefräse",                     # 10
        13=>"Streuwagen",                      # 10
        14=>"Kleinbus (Van etc.)",             #  7
        15=>"Pritschenwagen"                   #  7
      },
      
      :years => {
        1=>"01/2001",  # 3000
        2=>"01/1987",  # 0
        3=>"01/1989",  # 0
        4=>"01/1990",  # 0
        5=>"01/1993",  # 0
        6=>"01/1995",  # 2000
        7=>"01/1980",  # 0
        8=>"01/1986",  # 0
        9=>"01/1980",  # 0
        10=>"01/1988", # 0
        11=>"01/1984", # 0
        12=>"01/1980", # 0
        13=>"01/1980", # 0
        14=>"01/2001", # 3000
        15=>"01/1980"  # 0
      },
      
      :costs => {
        1  => 21000.0, 
        2  => 20000.0, 
        3  => 20000.0, 
        4  => 20000.0, 
        5  => 20000.0, 
        6  => 24000.0, 
        7  => 20000.0, 
        8  => 20000.0, 
        9  => 20000.0, 
        10 => 20000.0,
        11 => 20000.0, 
        12 => 20000.0, 
        13 => 20000.0, 
        14 => 21000.0, 
        15 => 20000.0
      }
    }
    
    eval(program, env).should be_close(8000, 0.01)
  end

  it "should evaluate 'vehicle_costs_per_km'" do
    program = <<-PROGRAM
      require 'stdlib/total_amortization';
      total_cost = AVG(f) + AVG(g) + AVG(h) + total_amortization(c, d, e);
      total_length = AVG(a);
      if(total_length != 0)
        total_cost / total_length
      else
        0
      end
    PROGRAM
    env = {
      
      :TIME_LINE_ROOT => 2003,
      
      :a => [22.0, 21.0, 21.0], # AVG = 21.34
      
      :c => { 
        1=>"Kleinbus (Van etc.)",              #  7
        2=>"Pritschenwagen",                   #  7
        3=>"PKW",                              #  7
        4=>"LKW",                              #  9
        5=>"Omnibus",                          #  9
        6=>"Radlader (z.B. Volvo L90D)",       # 12
        7=>"Traktor groß (z.B. Steyr 8075)",   # 12
        8=>"Traktor klein (KUBOTA etc.)",      # 10
        9=>"Unimog",                           # 12
        10=>"Zugmaschine (z.B. Holder C9.88)", # 12
        11=>"Kehrmaschine",                    # 10
        12=>"Schneefräse",                     # 10
        13=>"Streuwagen",                      # 10
        14=>"Kleinbus (Van etc.)",             #  7
        15=>"Pritschenwagen"                   #  7
      },
      
      :d => {
        1=>"01/2001",  # 3000
        2=>"01/1987",  # 0
        3=>"01/1989",  # 0
        4=>"01/1990",  # 0
        5=>"01/1993",  # 0
        6=>"01/1995",  # 2000
        7=>"01/1980",  # 0
        8=>"01/1986",  # 0
        9=>"01/1980",  # 0
        10=>"01/1988", # 0
        11=>"01/1984", # 0
        12=>"01/1980", # 0
        13=>"01/1980", # 0
        14=>"01/2001", # 3000
        15=>"01/1980"  # 0
      },
      
      :e => {
        1  => 21000.0, 
        2  => 20000.0, 
        3  => 20000.0, 
        4  => 20000.0, 
        5  => 20000.0, 
        6  => 24000.0, 
        7  => 20000.0, 
        8  => 20000.0, 
        9  => 20000.0, 
        10 => 20000.0,
        11 => 20000.0, 
        12 => 20000.0, 
        13 => 20000.0, 
        14 => 21000.0, 
        15 => 20000.0
      },
      
      :f => [5789.0, 4856.0, 5685.0], # AVG = 5443.33
      :g => [185.0, 325.0, 1256.0],   # AVG =  588.67
      :h => [1322.0, 1290.0, 1307.0], # AVG = 1306.33
                                      # --------------------------
                                      #       7338.33
                                      #       8000.00 AMORTIZATION
                                      # --------------------------
                                      #      15338.33 / 21.33
                                      # --------------------------
                                      #        719.09
    }
    eval(program, env).should be_close(719, 0.1)
  end
  
  it "should include 'avg_utilization_ratio'" do
    program = <<-PROGRAM
      require 'stdlib/avg_utilization_ratio';
      avg_utilization_ratio("PKW", a, b);
    PROGRAM
    env = {
      :TIME_LINE_ROOT => 2007,
      :a => { 1 => "PKW", 2 => "PKW" },
      :b => { 1 => 1500.0, 2 =>  700.0 }
    }
    eval(program, env).should be_close(256.667522225074, 0.01)
  end
  
  it "should include 'total_avg_utilization_ratio'" do
    program = <<-PROGRAM
      require 'stdlib/total_avg_utilization_ratio';
      total_avg_utilization_ratio(a, b);
    PROGRAM
    env = {
      :TIME_LINE_ROOT => 2007,
      :a => { 1 => "PKW", 2 => "PKW", 3 => "LKW", 4 => "Unimog" },
      :b => { 1 => 1500.0, 2 =>  700.0, 3 => 800.0, 4 => 1000.0 }
    }
    eval(program, env).should be_close(198.334211117037, 0.01)
  end
  
  
  it "should include 'avg_working_costs'" do
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
      :c => { 
        1 => [ 100, 100, 100 ],
        2 => [ 400, 400, 400 ],
        3 => [ 900, 900, 900 ],
      },
      :d => { 
        1 => [ 10, 10, 10 ],
        2 => [ 20, 20, 20 ],
        3 => [ 30, 30, 30 ],
      }
    })
    req_stmt = "require 'stdlib/avg_working_costs';"
    eval("#{req_stmt} avg_working_costs('Feuerwehrgebäude');", env).should == 10
    eval("#{req_stmt} avg_working_costs('Schulgebäude');    ", env).should == 20
    eval("#{req_stmt} avg_working_costs('Wohngebäude');     ", env).should == 30
  end
  
  it "should include 'avg_heating_costs'" do
    env = Trxl::Environment.new({
      :a => {
        1 => "Wasserwehr", 
        2 => "Hauptschule", 
        3 => "Bauhof", 
        4 => "Kindergarten",
        5 => "Gemeindeamt" 
      },
      :b => {
        1 => "Feuerwehrgebäude", 
        2 => "Schulgebäude", 
        3 => "Sonstige", 
        4 => "Kindergartengebäude",
        5 => "Verwaltungs- /Bürogebäude" 
      },
      :c => { 
        1 => [ 845.0, 820.0, 620.0 ],     #   761.666666666667
        2 => [ 6890.0, 8750.0, 7250.0 ],  #  7630.0
        3 => [ 895.0, 1026.0, 1090.0 ],   #  1003.66666666667
        4 => [ 4200.0, 3800.0, 3120.0 ],  #  3706.66666666667
        5 => [ 3652.0, 3485.0, 3685.0 ]   #  3607.33333333333
                                          # ----------------
                                          # 16709.3333333333
      },
      :d => {
        1 => [ 58.0, 585.0, 47.0 ],       #  230.0
        2 => [ 842.0, 125.0, 365.0 ],     #  444.0
        3 => [ 215.0, 356.0, 100.0 ],     #  223.666666666667
        4 => [ 22.0, 14.0, 14.0 ],        #   16.6666666666667
        5 => [ 458.0, 256.0, 352.0 ]      #  355.333333333333
                                          # -----------------
                                          # 1269.66666666667
      },
      :e => {
        1 => [ 121.0, 121.0, 121.0 ],     # 121.0
        2 => [ 85.0, 85.0, 85.0 ],        #  85.0
        3 => [ 25.0, 25.0, 25.0 ],        #  25.0
        4 => [ 62.0, 62.0, 62.0 ],        #  62.0
        5 => [ 45.0, 15.0, 200.0 ]        #  86.6666666666667
                                          # -----------------
                                          # 379.6666666666667
      },
      :f => {
        1 => [ 250.0, 250.0, 250.0 ],     #  250.0
        2 => [ 1980.0, 1980.0, 1980.0 ],  # 1980.0
        3 => [ 510.0, 510.0, 510.0 ],     #  510.0
        4 => [ 360.0, 360.0, 360.0 ],     #  360.0
        5 => [ 420.0, 420.0, 420.0 ]      #  420.0
                                          # ------
                                          # 3520.0
                                          # ------
                                          # 18358.6666666667 / 3520.0
                                          # -------------------------
                                          # 5.21553030303031
      }
    })
  
    # Verwaltungs/Bürogebäude =  9.64126984126983
    # Feuerwehrgebäude        =  4.45066666666667
    # Schulgebäude            =  4.12070707070707
    # Sonstige                =  2.45555555555556
    # Kindergartengebäude     = 10.5148148148148
    # Wohngebäude             = NULL
    req_stmt = "require 'stdlib/avg_heating_costs';"
    eval("#{req_stmt} avg_heating_costs('Feuerwehrgebäude');         ", env).should be_close(4.45, 0.01)
    eval("#{req_stmt} avg_heating_costs('Schulgebäude');             ", env).should be_close(4.12, 0.01)
    eval("#{req_stmt} avg_heating_costs('Sonstige');                 ", env).should be_close(2.46, 0.01)
    eval("#{req_stmt} avg_heating_costs('Kindergartengebäude');      ", env).should be_close(10.51, 0.01)
    eval("#{req_stmt} avg_heating_costs('Verwaltungs- /Bürogebäude');", env).should be_close(9.64, 0.01)
    eval("#{req_stmt} avg_heating_costs('Wohngebäude');              ", env).should be_nil
  end
  
  it "should include 'avg_maintenance_costs'" do
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
      :c => { 
        1 => [ 100, 100, 100 ],
        2 => [ 400, 400, 400 ],
        3 => [ 900, 900, 900 ],
      },
      :d => { 
        1 => [ 10, 10, 10 ],
        2 => [ 20, 20, 20 ],
        3 => [ 30, 30, 30 ],
      }
    })
    req_stmt = "require 'stdlib/avg_maintenance_costs';"
    eval("#{req_stmt} avg_maintenance_costs('Feuerwehrgebäude');", env).should == 10
    eval("#{req_stmt} avg_maintenance_costs('Schulgebäude');    ", env).should == 20
    eval("#{req_stmt} avg_maintenance_costs('Wohngebäude');     ", env).should == 30
  end
  
  it "should include 'cleaning_efficiency'" do
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
        1 => [ 1500, 1500, 1500 ],
        2 => [ 2000, 2000, 2000 ],
        3 => [ 3000, 3000, 3000 ]
      }
    })
    req_stmt = "require 'stdlib/cleaning_efficiency';"
    eval("#{req_stmt} cleaning_efficiency('Feuerwehrgebäude');", env).should == 1.11
    eval("#{req_stmt} cleaning_efficiency('Schulgebäude');    ", env).should == 0.37
    eval("#{req_stmt} cleaning_efficiency('Wohngebäude');     ", env).should == 0.25
    eval("#{req_stmt} cleaning_efficiency('Sonstige');        ", env).should be_nil
  end
  
  it "should be able to calculate 'total_working_costs'" do
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
      :c => { 
        1 => [ 100, 100, 100 ],
        2 => [ 400, 400, 400 ],
        3 => [ 900, 900, 900 ],
      },
      :d => { 
        1 => [ 10, 10, 10 ],
        2 => [ 20, 20, 20 ],
        3 => [ 30, 30, 30 ],
      }
    })
  
    program = <<-PROGRAM
      require 'stdlib/map';
      total_costs = SUM(map(TO_ARRAY(c), fun(pair) { pair[1] }));
      total_area = SUM(map(TO_ARRAY(d), fun(pair) { pair[1] }));
      if(total_area != NULL)
        ROUND(total_costs / total_area, 2)
      else
        NULL
      end
    PROGRAM
    eval(program, env).should be_close(23.33, 0.01)
  end
  
  it "should be able to calculate 'total_heating_costs'" do
    env = Trxl::Environment.new({
      :a => {
        1 => "Wasserwehr", 
        2 => "Hauptschule", 
        3 => "Bauhof", 
        4 => "Kindergarten",
        5 => "Gemeindeamt" 
      },
      :b => {
        1 => "Feuerwehrgebäude", 
        2 => "Schulgebäude", 
        3 => "Sonstige", 
        4 => "Kindergartengebäude",
        5 => "Verwaltungs- /Bürogebäude" 
      },
      :c => { 
        1 => [ 845.0, 820.0, 620.0 ],     #   761.666666666667
        2 => [ 6890.0, 8750.0, 7250.0 ],  #  7630.0
        3 => [ 895.0, 1026.0, 1090.0 ],   #  1003.66666666667
        4 => [ 4200.0, 3800.0, 3120.0 ],  #  3706.66666666667
        5 => [ 3652.0, 3485.0, 3685.0 ]   #  3607.33333333333
                                          # ----------------
                                          # 16709.3333333333
      },
      :d => {
        1 => [ 58.0, 585.0, 47.0 ],       #  230.0
        2 => [ 842.0, 125.0, 365.0 ],     #  444.0
        3 => [ 215.0, 356.0, 100.0 ],     #  223.666666666667
        4 => [ 22.0, 14.0, 14.0 ],        #   16.6666666666667
        5 => [ 458.0, 256.0, 352.0 ]      #  355.333333333333
                                          # -----------------
                                          # 1269.66666666667
      },
      :e => {
        1 => [ 121.0, 121.0, 121.0 ],     # 121.0
        2 => [ 85.0, 85.0, 85.0 ],        #  85.0
        3 => [ 25.0, 25.0, 25.0 ],        #  25.0
        4 => [ 62.0, 62.0, 62.0 ],        #  62.0
        5 => [ 45.0, 15.0, 200.0 ]        #  86.6666666666667
                                          # -----------------
                                          # 379.6666666666667
      },
      :f => {
        1 => [ 250.0, 250.0, 250.0 ],     #  250.0
        2 => [ 1980.0, 1980.0, 1980.0 ],  # 1980.0
        3 => [ 510.0, 510.0, 510.0 ],     #  510.0
        4 => [ 360.0, 360.0, 360.0 ],     #  360.0
        5 => [ 420.0, 420.0, 420.0 ]      #  420.0
                                          # ------
                                          # 3520.0
                                          # ------
                                          # 18358.6666666667 / 3520.0
                                          # -------------------------
                                          # 5.21553030303031
      }
    })
  
    program = <<-PROGRAM
      require 'stdlib/map';
      costs = TO_ARRAY(c) + TO_ARRAY(d) + TO_ARRAY(e);
      total_costs = SUM(map(costs, fun(pair) { pair[1] }));
      total_area = SUM(map(TO_ARRAY(f), fun(pair) { pair[1] }));
      if(total_area != NULL)
        ROUND(total_costs / total_area, 2)
      else
        NULL
      end
    PROGRAM
    eval(program, env).should be_close(5.22, 0.01)
  end
  
  it "should be able to calculate 'total_maintenance_costs'" do
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
      :c => { 
        1 => [ 100, 100, 100 ],
        2 => [ 400, 400, 400 ],
        3 => [ 900, 900, 900 ],
      },
      :d => { 
        1 => [ 10, 10, 10 ],
        2 => [ 20, 20, 20 ],
        3 => [ 30, 30, 30 ],
      }
    })
  
    program = <<-PROGRAM
      require 'stdlib/map';
      total_costs = SUM(map(TO_ARRAY(c), fun(pair) { pair[1] }));
      total_area = SUM(map(TO_ARRAY(d), fun(pair) { pair[1] }));
      if(total_area != NULL)
        ROUND(total_costs / total_area, 2)
      else
        NULL
      end
    PROGRAM
    eval(program, env).should be_close(23.33, 0.01)
  end
  
  it "should be able to calculate 'total_cleaning_efficiency'" do
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
        1 => [ 1500, 1500, 1500 ],
        2 => [ 2000, 2000, 2000 ],
        3 => [ 3000, 3000, 3000 ]
      }
    })
  
    program = <<-PROGRAM
      require 'stdlib/map';
      require 'stdlib/cleaning_expenses';

      instance_values = fun(variable_name) {
        map(TO_ARRAY(ENV[variable_name]), fun(pair) { pair[1] })
      };

      norm_expenses = inject(0, TO_ARRAY(b), fun(total, type) {
        total + cleaning_expenses(type[1], 'c'..'t')
      });

      expenses = AVG_SUM(instance_values('u'));

      if(norm_expenses && norm_expenses != 0)
        ROUND(expenses / norm_expenses * 100, 2)
      else
        NULL
      end
    PROGRAM
    eval(program, env).should == 1.73
  end
  
  it "should be able to calculate 'total_cleaning_expenses'" do
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
        1 => [ 1500, 1500, 1500 ],
        2 => [ 2000, 2000, 2000 ],
        3 => [ 3000, 3000, 3000 ]
      }
    })
  
    program = <<-PROGRAM
      require 'stdlib/map';
      require 'stdlib/cleaning_expenses';

#      instance_values = fun(variable_name) {
#        map(TO_ARRAY(ENV[variable_name]), fun(pair) { pair[1] })
#      };
#
#      total_cleaning_expenses = fun(variable_range) {
#        SUM(in_groups_of(3, variable_range, fun(group, group_nr) {
#          area     = SUM(instance_values(group[0]));
#          per_week = SUM(instance_values(group[1]));
#          per_year = SUM(instance_values(group[2]));
##          PRINT('area:     '); PRINT_LINE(area);
##          PRINT('per_week  '); PRINT_LINE(per_week);
##          PRINT('per_year: '); PRINT_LINE(per_year);
#          x = cleaning_expenses_for_category(group_nr, area, per_week, per_year);
##          PRINT('expenses: '); PRINT_LINE(x);
#          x
#        }))
#      };

      total_cleaning_expenses = fun(variable_range) {
        inject(0, TO_ARRAY(b), fun(total, type) {
          total + cleaning_expenses(type[1], 'c'..'t')
        })
      };

      total_cleaning_expenses('c'..'t');
    PROGRAM
    eval(program, env).should == 1883700.0
  end
  
end
