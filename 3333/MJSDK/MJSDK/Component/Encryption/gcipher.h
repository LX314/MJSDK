// Copyright(c) 2016, weimob.com Inc.
// Author: ZHOU Lizhi <lizhi.zhou@weimob.com>
#ifndef COMMON_CIPHER_GCIPHER_H_
#define COMMON_CIPHER_GCIPHER_H_

#include <string>
#include <map>
#include <vector>
//#include "common/base/nocopy.h"

namespace common {
namespace cipher {
    
    enum {BASE64_OK = 0, BASE64_INVALID};

class GCipher {
 public:
  GCipher(const std::string& hex_ekey, const std::string& hex_ikey);

  bool Cipher(const std::string& raw, std::string* ciphered);
  bool Cipher(const std::string& raw, const std::string& iv, std::string* ciphered);
  bool Decipher(const std::string& ciphered, std::string* raw);

  static std::string Hex2Bytes(const std::string& hex_str);
    
    
    int base64_encode(const unsigned char *in, unsigned int inlen, char *out);
    
    int base64_decode(const char *in, unsigned int inlen, unsigned char *out);

 private:

  std::string GenInitVector();
  void AddIVCounter(std::string* iv, bool* flag);
  bool GetIntegrityHash(std::string& input, unsigned char* ihash);

  std::string hex_ekey_;
  std::string hex_ikey_;

  std::string ekey_;
  std::string ikey_;

  static const size_t kInitVectorSize = 16;
  static const size_t kSignatureSize = 4;
  static const size_t kBlockSize = 20;
  static const size_t kKeySize = 32;
  static const size_t kHashSize = 32;
};
}
}

using common::cipher::GCipher;

#endif


