class IrcDH1080
  module Base64
    # The Base64 characters used for IRC DH1080
    B64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'.freeze

    # Encodes a binary string in modified IRC DH1080 Base64
    # @param bin [String] binary encoded string to be encoded
    # @return [String] the Base64 encoded string
    def self.encode(bin)
      str = ''

      i, j, t, m = 0, 0, 0, 0x80
      l = bin.bytesize * 8

      while i < l
        t |= 1 unless bin[i>>3].ord & m == 0
        j += 1
        m >>= 1
        m = 0x80 if m == 0

        if j % 6 == 0
          str += B64[t]
          t &= 0
        end

        t = (t << 1) % 0x100
        i += 1
      end

      m = 5 - (j % 6)
      str += B64[(t << m) % 0x100] unless m == 0
      str
    end

    # Decodes an IRC DH1080 Base64 string
    # @param str [String] the Base64 encoded string
    # @return [String] the decoded string
    def self.decode(str)
      l = str.bytesize
      return str if l < 2

      buf = [0] * 256
      B64.each_byte.with_index { |x,i| buf[x] = i }

      str.reverse.each_byte do |x,i|
        break if buf[x] == 0
        l -= 1
      end

      return str if l < 2

      d = [0] * l

      i, k = 0, 0

      while true
        break unless k + 1 < l
        d[i] = (buf[str[k].ord] << 2) % 0x100
        d[i] |= buf[str[k+=1].ord] >> 4

        break unless k + 1 < l
        i += 1
        d[i] = (buf[str[k].ord] << 4) % 0x100
        d[i] |= buf[str[k+=1].ord] >> 2

        break unless k + 1 < l
        i += 1
        d[i] = (buf[str[k].ord] << 6) % 0x100
        d[i] |= buf[str[k+=1].ord] % 0x100

        i += 1
        k += 1
      end

      d[0,i].map { |x| x.chr }.join('')
    end
  end
end
