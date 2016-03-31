class Glove::ShaderProgram
  def initialize
    @program_id = LibGL.create_program
    @uniform_locations = {} of String => Int32
  end

  def self.from(vertex_shader_filename, fragment_shader_filename)
    vertex_shader_code = File.read(vertex_shader_filename)
    fragment_shader_code = File.read(fragment_shader_filename)

    vertex_shader = Glove::Shader.vertex(vertex_shader_code).compile
    fragment_shader = Glove::Shader.fragment(fragment_shader_code).compile

    program = Glove::ShaderProgram.new
    program.attach(vertex_shader)
    program.attach(fragment_shader)
    program.link

    vertex_shader.delete
    fragment_shader.delete

    program
  end

  def program_id
    @program_id
  end

  def attach(shader)
    LibGL.attach_shader @program_id, shader.shader_id
    self
  end

  def link
    LibGL.link_program @program_id

    LibGL.get_program_iv @program_id, LibGL::LINK_STATUS, out result
    LibGL.get_program_iv @program_id, LibGL::INFO_LOG_LENGTH, out info_log_length
    info_log = String.new(info_log_length) do |buffer|
      LibGL.get_program_info_log @program_id, info_log_length, nil, buffer
      {info_log_length, info_log_length}
    end
    raise "Error linking shader program: #{info_log}" unless result

    self
  end

  def use
    LibGL.use_program @program_id
    self
  end

  def get_uniform_location_cached(name)
    @uniform_locations[name] ||= LibGL.get_uniform_location(@program_id, name.to_unsafe)
  end

  def set_uniform_matrix_4f(name, transpose, data)
    location =get_uniform_location_cached(name)
    LibGL.uniform_matrix_4fv location, 1, GL.to_boolean(transpose), data
  end
end
