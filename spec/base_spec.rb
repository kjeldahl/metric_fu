require File.dirname(__FILE__) + '/spec_helper.rb'

describe MetricFu::Base::Generator do
  describe "save_html" do
    it "should save to a index.html in the base_dir" do
      @generator = MetricFu::Base::Generator.new
      @generator.should_receive(:open).with("#{MetricFu::BASE_DIRECTORY}/generator/index.html", "w")
      @generator.save_html("<html>")
    end

    it "should save to a custom.html to the base_dir if 'custom' is passed as name" do
      @generator = MetricFu::Base::Generator.new
      @generator.should_receive(:open).with("#{MetricFu::BASE_DIRECTORY}/generator/metric_fu/custom.html", "w")
      @generator.save_html("<html>", 'metric_fu/custom.html')
    end
  end

  describe "generate_report class method" do
    it "should create a new Generator and call generate_report on it" do
      @generator = mock('generator')
      @generator.should_receive(:generate_report)
      MetricFu::Base::Generator.should_receive(:new).and_return(@generator)
      MetricFu::Base::Generator.generate_report('base_dir')
    end
  end

  describe "generate_html" do
    it "should create a new Generator and call generate_report on it" do
      @generator = MetricFu::Base::Generator.new
      @generator.should_receive(:open).with("#{MetricFu::BASE_DIRECTORY}/generator/index.html", "w")
      @generator.should_receive(:generate_html).and_return('<html>')
      @generator.generate_report
    end
  end
  
  describe "cycle" do
    it "should create a new Generator and call generate_report on it" do
      @generator = MetricFu::Base::Generator.new
      @generator.cycle("light", "dark", 0).should == 'light'
      @generator.cycle("light", "dark", 1).should == 'dark'      
    end
  end
  
  describe "template_name" do
    it "should return the class name in lowercase" do
      @generator = MetricFu::Base::Generator.new
      @generator.template_name.should == 'generator'
    end
  end

  describe "metric_dir" do
    it "should return tmp/metric_fu/{the class name in lowercase}" do
      MetricFu::Base::Generator.metric_dir.should == "#{MetricFu::BASE_DIRECTORY}/generator"
    end
  end

  describe "link_to_filename", "when run_by_cruise_control and a url_prefix is specfied" do
    before(:each) do
      @generator = MetricFu::Base::Generator.new
      MetricFu.should_receive(:run_by_cruise_control?).at_least(1).and_return(true)
    end

    it "should return a link using the prefix" do
      MetricFu::Configuration.run do |config|
        config.general  = { :open_in_browser => true, :url_prefix => 'prefix' }
      end

      link = @generator.link_to_filename("app/model/foo.rb", 23)
      link.should == %{<a href="prefix/app/model/foo.rb?line=23#23">app/model/foo.rb</a>}
    end
    it "should return a link using the prefix even if the prefix ends with /" do
      MetricFu::Configuration.run do |config|
        config.general  = { :open_in_browser => true, :url_prefix => 'prefix/' }
      end

      link = @generator.link_to_filename("app/model/foo.rb", 23)
      link.should == %{<a href="prefix/app/model/foo.rb?line=23#23">app/model/foo.rb</a>}
    end
  end
end