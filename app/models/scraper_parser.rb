require 'open-uri'
require 'hpricot'
require 'ostruct'
require 'net/http'
require 'uri'

class ScraperParser
  attr_accessor :_description, :_name, :_default, :_hits, :_data_group_name
  attr_reader :site, :data, :tasks

  def initialize(script = nil)
    @hits = 10
    @data = ''
    @tasks = {}
    @results = []
    @trace = []
    @site = OpenStruct.new()
    @args = {}
    load(script) if script
  end

  def load(script)
    instance_eval script
  end

  def task(name, options = {}, &block)
    method_name = name.to_s.gsub(/^private\s+/, '').to_sym

    @tasks[method_name] = {}
    @tasks[method_name][:args] = options[:args] if options[:args]
    @tasks[method_name][:private] = name.match(/^private/) ? true : false

    define_method(method_name) do |*args|
      @results = []
      @trace.push current_method

      @tasks[method_name][:args].each_with_index do |param_name, index|
        unless @args[method_name]
          klass = Struct.new(*@tasks[method_name][:args].collect { |p| p.to_sym }) unless @args[method_name]
          @args[method_name] = klass.new
        end
        @args[method_name].send(param_name + '=', args[index])
      end

      instance_eval &block

      @trace.pop
      @results
    end
  end

  def params(sym)
    @args[@current_method].send(sym)
  end

  def site(&block)
    if block
      @defining_site = true
      instance_eval &block
      @defining_site = false
    end
    return @site
  end

  def get(url, *args)
    url = insert_url_params(url, args.first) if args.first
    http = Net::HTTP.new(URI.parse(url), 80)
    response, data = http.get(path, nil)
    @cookie = response.response['set-cookie']
    @last_url = url
    @data = Hpricot open(url)
  end

  def post(url, *args)
    headers = {
      'Cookie' => @cookie,
      'Referer' => @last_url,
      'Content-Type' => 'application/x-www-form-urlencoded'
    }

    
    result = Net::HTTP.post_form(URI.parse(url), args, headers)
    @data = Hpricot result.body
  end

  # This works as an iterator when a block is passed
  def find_links_to(url, &block)
    url, selector = if url.kind_of? Array
      [url[1], url[0]]
    else
      [url, 'a']
    end
    
    links = (@data/selector).find_all do |link|
      link[:href].match(strip_url_params(url)) if link and link[:href]
    end
    
    links = links.compact.collect { |link| [link[:href], link.inner_text] }.uniq[0..@_hits - 1]
    
    links.collect do |link|
      yield link[0]
    end
  end

  def for_each(selector, options = {}, &block)
    results = []
    
    (@data/selector).collect do |item|
      items = if options[:find_first].kind_of? Array
        options[:find_first].collect do |sub_selector|
          result = find_first(sub_selector, item)
          replace_tags result if result
        end.compact
      elsif options[:find_first]
        find_first(options[:find_first], item)
      else
        replace_tags item.inner_text
      end
      
      items.empty? ? nil : items
    end.compact.uniq[0..@_hits - 1]
  end

  def find_value(selector)
    (@data/selector)
  end

  # Searches the last page fetched with get and returns html in tags using Hpricot
  def find_first(selector, data)
    data = @data unless data
    results = (data/selector)
    if results and results.first
      results.first.inner_html.strip
    else
      nil
    end
  end

  def find(selector, data = nil, &block)
    data = @data unless data
    
    if selector.kind_of? Array
      return selector.collect { |s| find(s, data, &block) }
    end
    
    (data/selector).collect do |elem|
      if block
        yield elem
      else
        elem.inner_text
      end
    end
  end

  def find_text(selector, data = nil, &block)
    data = @data unless data
    
    if selector.kind_of? Array
      return selector.collect { |s| find_text(s, data, &block).first }
    end

    (data/selector).collect do |elem|
      if block
        yield elem.inner_text
      else
        elem.inner_text
      end
    end
  end

  def collect_result(data)
    @results.push data
  end

  def save(data)
    @results = data
  end

  def replace_tags(text, replace = '')
    text.gsub(/(<[^>]+?>|&nbsp;)/, replace).strip.gsub(/[\s\t]+/, ' ').gsub(/\243/, '&pound;')
  end

  private

    def metaclass
      class << self; self; end
    end

    def method_missing(sym, *args)
      if @defining_site
        @site.send(sym.to_s + '=', args[0])
      elsif [:description, :name, :default, :hits, :data_group_name].include? sym
        send('_' + sym.to_s + '=', args[0])
      elsif respond_to? sym
        send(sym, args)
      elsif @args[@trace.last] and @args[@trace.last].members.include? sym.to_s
        return @args[@trace.last].send(sym)
      else
        puts "ScraperParser#method_missing: not found"
        p @args[@trace.last].members
        p sym.to_s + ' not found'
        super
      end
    end
    
    def define_method(name, &block)
      metaclass.send(:define_method, name, &block)
    end
    
    def strip_url_params(url)
      url.gsub(/%s/, '')
    end
    
    def insert_url_params(url, *args)
      args.each do |arg|
        arg ||= ''
        url.gsub!(/%s/, CGI.escape(arg))
      end

      return url
    end
    
    def current_method
      caller[0].sub(/.*`([^']+)'/, '\1').to_sym
    end
end

