module MetricFu
  
  def self.generate_reek_report
    Reek.generate_report
    system("open #{Reek.metric_dir}/index.html") if open_in_browser?    
  end
    
  class Reek < Base::Generator

    def analyze
      files_to_reek = MetricFu.reek[:dirs_to_reek].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      output = `reek #{files_to_reek.join(" ")}`
      @matches = output.chomp.split("\n\n").map{|m| m.split("\n") }
      @filenames = extract_filenames(@matches.map {|m| m.first})
    end

    private
    def extract_filenames(names)
      names.map do |name|
        m = name.match(/^"(.*)"/)
        m.size == 2 ? m[1] : nil
      end
    end
  end
end