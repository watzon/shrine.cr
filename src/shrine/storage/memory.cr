require "./base"

class Shrine
  module Storage
    class Memory < Storage::Base
      getter store
      getter? clean

      def initialize(store : Hash = {} of String => String)
        @store = store
        @clean = false
      end

      def upload(io, id, **options)
        # store[id.to_s] = io.read
        store[id.to_s] = io.gets_to_end
      end

      def open(id)
        # StringIO.new(store.fetch(id))

      rescue KeyError
        raise Shrine::FileNotFound.new("file #{id.inspect} not found on storage")
      end

      def exists?(id)
        store.has_key?(id)
      end

      def url(id)
        "memory://#{path(id)}"
      end

      def path(id)
        id
      end

      def delete(id)
        store.delete(id)
      end

      def delete_prefixed(delete_prefix)
        delete_prefix = delete_prefix.chomp("/") + "/"
        store.delete_if { |key, _value| key.start_with?(delete_prefix) }
      end

      def clear!
        store.clear
      end
    end
  end
end