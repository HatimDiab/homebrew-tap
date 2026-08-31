class Llcpp < Formula
  include Language::Python::Shebang

  desc "Ollama-style CLI for llama.cpp: pull, run, search and serve GGUF models"
  homepage "https://github.com/HatimDiab/llcpp"
  url "https://github.com/HatimDiab/llcpp/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "760169ef4d4dba41ed800ce133334320301c74c4bcbafee004cade81f7213f0f"
  license "MIT"

  depends_on "llama.cpp"

  def install
    bin.install "llcpp"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"llcpp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llcpp --version")

    help = shell_output("#{bin}/llcpp help")
    %w[pull run serve search list ps stop rm].each do |cmd|
      assert_match cmd, help
    end

    # An empty cache must list cleanly rather than erroring.
    ENV["LLAMA_CACHE"] = testpath/"cache"
    assert_match "no models", shell_output("#{bin}/llcpp list")

    # Unknown subcommands are a usage error, not a traceback.
    output = shell_output("#{bin}/llcpp help nope 2>&1", 1)
    assert_match "no such command", output
  end
end
