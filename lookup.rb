def get_command_line_argument
    # ARGV is an array that Ruby defines for us,
    # which contains all the arguments we passed to it
    # when invoking the script from the command line.
    # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
    if ARGV.empty?
      puts "Usage: ruby lookup.rb <domain>"
      exit
    end
    ARGV.first
  end

  # `domain` contains the domain name we have to look up.
  domain = get_command_line_argument

  # File.readlines reads a file and returns an
  # array of string, where each element is a line
  # https://www.rubydoc.info/stdlib/core/IO:readlines
  dns_raw = File.readlines("zone")
  # ..
  # ..
  # FILL YOUR CODE HERE
  def parse_dns(dns_raw)
    dns_raw.delete_at(0)
    b=[]
     dns_raw.each do |item|
        str =  item == "\n"
          if !str
            b.push(item.split(','))
          end
      end
      len = b.length-1
      dns_records ={}
      for r in 0..len do
        for c in 1..2 do
            b[r][c] = b[r][c].strip
        end
      end
      domain1 = {}
      domain2 = {}
      for r in 0..len do
        if b[r][0] == 'A'
            domain1[b[r][1]]= b[r][2]
        else
          domain2[b[r][1]] = b[r][2]
        end
      end

      dns_records["A"] = domain1
      dns_records["CNAME"] = domain2

      return dns_records
  end

  def resolve(dns_records, lookup_chain, domain)
      if dns_records["A"].member?(domain)
          lookup_chain.push(dns_records["A"][domain])
      elsif  dns_records["CNAME"].member?(domain)
          lookup_chain.push(dns_records["CNAME"][domain])
          domain = dns_records["CNAME"][domain]
          resolve(dns_records,lookup_chain,domain)
      elsif  dns_records["CNAME"].value?(domain)

          domain = dns_records["CNAME"][domain]

           resolve(dns_records,lookup_chain,domain)
      else
          lookup_chain = []
          lookup_chain.push("Error: record not found for " + domain)
      end

  end

  # ..
  # ..

  # To complete the assignment, implement `parse_dns` and `resolve`.
  # Remember to implement them above this line since in Ruby
  # you can invoke a function only after it is defined.
  dns_records = parse_dns(dns_raw)
  lookup_chain = [domain]
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join(" => ")
