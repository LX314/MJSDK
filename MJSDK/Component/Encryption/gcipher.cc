// Copyright(c) 2016, weimob.com Inc.
// Author: ZHOU Lizhi <lizhi.zhou@weimob.com>
// Google's RTB encrypting/decrypting method
// for more information, plz go through
// https://developers.google.com/ad-exchange/rtb/response-guide/decrypt-advertising-id
//#include "common/cipher/gcipher.h"
#include "gcipher.h"
#include <cstring>
#include <algorithm>
#include <openssl/ssl.h>
#include <openssl/evp.h>
//#include "common/system/time/timestamp.h"
//#include "common/base/log.h"
//#include "common/base/stl_util.h"

namespace common {
namespace cipher {

using std::string;
typedef unsigned char uchar;

GCipher::GCipher(const string& hex_ekey, const string& hex_ikey):
    hex_ekey_(hex_ekey), hex_ikey_(hex_ikey) {
    ekey_ = Hex2Bytes(hex_ekey_);
    ikey_ = Hex2Bytes(hex_ikey_);
}

int8_t HexChar2Int(char ch) {
  if (ch >= '0' && ch <= '9') {
    return ch - '0';
  } else if (ch >= 'a' && ch <= 'f') {
    return ch - 'a' + 10;
  } else if (ch >= 'A' && ch <= 'F') {
    return ch - 'A' + 10;
  }
  return -1;
}

string GCipher::Hex2Bytes(const string& hex_str) {
  string bytes;
  if (hex_str.size() % 2) {
    return "";
  }
  for (size_t i = 0; i < hex_str.size() - 1; i+= 2) {
    int8_t upper = HexChar2Int(hex_str[i]);
    int8_t lower = HexChar2Int(hex_str[i + 1]);
    if (lower < 0 || upper < 0) {
      return "";
    }
    bytes.push_back(upper << 4 | lower);
  }
  return bytes;
}

bool GCipher::Cipher(const string& raw, string* ciphered) {
  return Cipher(raw, GenInitVector(), ciphered);
}
    inline char* string_as_array(std::string* str) {
        // DO NOT USE const_cast<char*>(str->data())! See the unittest for why.
        return str->empty() ? NULL : &*str->begin();
    }
bool GCipher::Decipher(const string& ciphered, string* raw) {
  if (ekey_.empty() || ikey_.empty()) {
//    LOG(ERROR) << "invalid gcipher key set";
    return false;
  }
  const size_t raw_length = ciphered.size() - kInitVectorSize - kSignatureSize;
  if (raw_length <= 0) {
    return false;
  }
  string iv(ciphered, 0, kInitVectorSize);
  raw->clear();
  raw->resize(raw_length, '\0');

  string::const_iterator cipher_begin = ciphered.cbegin() + iv.size();
  string::const_iterator cipher_end   = cipher_begin + raw->size();
  string::iterator       raw_begin    = raw->begin();

  bool add_iv_counter_byte = true;
  while (cipher_begin < cipher_end) {
    uint32_t pad_size = kHashSize;
    uchar pad[kHashSize] = {0};
    if (!HMAC(EVP_sha1(), string_as_array(&ekey_), ekey_.size(),
              reinterpret_cast<uchar*>(string_as_array(&iv)), iv.size(),
              pad, &pad_size)) {
//      LOG(ERROR) << "generating HMAC failed";
      return false;
    }
    for (size_t i = 0; i < kBlockSize && cipher_begin < cipher_end;
         i++, ++raw_begin, ++cipher_begin) {
      *raw_begin = *cipher_begin ^ pad[i];
    }
    if (!add_iv_counter_byte) {
      char& last_byte = *iv.rbegin();
      ++last_byte;
      if (last_byte == '\0') {
        add_iv_counter_byte = true;
      }
    }
    if (add_iv_counter_byte) {
      add_iv_counter_byte = false;
      iv.push_back('\0');
    }
  }

  // compute integrity hash
  string integrity_input;
  integrity_input.append(*raw);
  integrity_input.append(ciphered.substr(0, kInitVectorSize));
  uchar  integrity_hash[kHashSize];

  if (GetIntegrityHash(integrity_input, integrity_hash)) {
    return std::memcmp(&(*cipher_end), integrity_hash, kSignatureSize) == 0;
  }
  return false;
}


string GCipher::GenInitVector() {
  string iv(kInitVectorSize, '\0');
  auto randchar = []() -> char {
    return static_cast<char>(rand() % 128);
  };
  std::generate_n(iv.begin(), iv.size(), randchar);
  return iv;
}

bool GCipher::Cipher(const std::string& raw,
                     const std::string& init_vector,
                     std::string* ciphered) {
  string iv = init_vector;
  iv.resize(kInitVectorSize);
  const size_t ciphered_length = raw.size() + kInitVectorSize + kSignatureSize;
  ciphered->clear();
  ciphered->append(iv);
  // make space for ciphered_text
  ciphered->resize(ciphered_length - kSignatureSize);

  string::const_iterator raw_begin = raw.cbegin();
  string::const_iterator raw_end   = raw.end();
  string::iterator       cipher_begin = ciphered->begin() + kInitVectorSize;
  bool add_iv_counter_byte = true;

  while (raw_begin < raw_end) {
    uint32_t pad_size = kHashSize;
    uchar pad[kHashSize] = {0};
    if (!HMAC(EVP_sha1(), string_as_array(&ekey_), ekey_.size(),
              reinterpret_cast<uchar*>(string_as_array(&iv)), iv.size(),
              pad, &pad_size)) {
//      LOG(ERROR) << "generating HMAC failed";
      return false;
    }
    for (size_t i = 0; i < kBlockSize && raw_begin < raw_end;
         i++, ++raw_begin, ++cipher_begin) {
      *cipher_begin = *raw_begin ^ pad[i];
    }
    AddIVCounter(&iv, &add_iv_counter_byte);
  }

  // compute and append integrity hash
  string integrity_input;
  integrity_input.append(raw);
  integrity_input.append(init_vector.substr(0, kInitVectorSize));
  uchar  integrity_hash[kHashSize];
  if (!GetIntegrityHash(integrity_input, integrity_hash)) {
    return false;
  }
  ciphered->append(reinterpret_cast<char*>(integrity_hash), kSignatureSize);
  return true;
}

bool GCipher::GetIntegrityHash(std::string& input, uchar* ihash) {
  uint32_t hash_size = kHashSize;
  if (!HMAC(EVP_sha1(), string_as_array(&ikey_), ikey_.size(),
            reinterpret_cast<uchar*>(string_as_array(&input)),
            input.size(), ihash, &hash_size)) {
//    LOG(ERROR) << "cannot compute integrity hash";
    return false;
  }
  return true;
}

// this makes each encrypting block using different IVs,
// otherwise the encrypted text can be easily cracked
void GCipher::AddIVCounter(std::string* iv, bool* flag) {
  if (!*flag) {
    char& last_byte = *(iv->rbegin());
    ++last_byte;
    if (last_byte == '\0') {
      *flag = true;
    }
  }
  if (*flag) {
    *flag = false;
    iv->push_back('\0');
  }
}
    
    /* BASE 64 encode table */
    static const char base64en[] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
        'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
        'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
        'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3',
        '4', '5', '6', '7', '8', '9', '+', '/',
    };
    
#define BASE64_PAD	'='
    
    
#define BASE64DE_FIRST	'+'
#define BASE64DE_LAST	'z'
    /* ASCII order for BASE 64 decode, -1 in unused character */
    static const signed char base64de[] = {
        /* '+', ',', '-', '.', '/', '0', '1', '2', */
        62,  -1,  -1,  -1,  63,  52,  53,  54,
        
        /* '3', '4', '5', '6', '7', '8', '9', ':', */
        55,  56,  57,  58,  59,  60,  61,  -1,
        
        /* ';', '<', '=', '>', '?', '@', 'A', 'B', */
        -1,  -1,  -1,  -1,  -1,  -1,   0,   1,
        
        /* 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', */
        2,   3,   4,   5,   6,   7,   8,   9,
        
        /* 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', */
        10,  11,  12,  13,  14,  15,  16,  17,
        
        /* 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', */
        18,  19,  20,  21,  22,  23,  24,  25,
        
        /* '[', '\', ']', '^', '_', '`', 'a', 'b', */
        -1,  -1,  -1,  -1,  -1,  -1,  26,  27,
        
        /* 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', */
        28,  29,  30,  31,  32,  33,  34,  35,
        
        /* 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', */
        36,  37,  38,  39,  40,  41,  42,  43,
        
        /* 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', */
        44,  45,  46,  47,  48,  49,  50,  51,
    };
    
    int base64_encode(const unsigned char *in, unsigned int inlen, char *out)
    {
        unsigned int i, j;
        
        for (i = j = 0; i < inlen; i++) {
            int s = i % 3; 			/* from 6/gcd(6, 8) */
            
            switch (s) {
                case 0:
                    out[j++] = base64en[(in[i] >> 2) & 0x3F];
                    continue;
                case 1:
                    out[j++] = base64en[((in[i-1] & 0x3) << 4) + ((in[i] >> 4) & 0xF)];
                    continue;
                case 2:
                    out[j++] = base64en[((in[i-1] & 0xF) << 2) + ((in[i] >> 6) & 0x3)];
                    out[j++] = base64en[in[i] & 0x3F];
            }
        }
        
        /* move back */
        i -= 1;
        
        /* check the last and add padding */
        if ((i % 3) == 0) {
            out[j++] = base64en[(in[i] & 0x3) << 4];
            out[j++] = BASE64_PAD;
            out[j++] = BASE64_PAD;
        } else if ((i % 3) == 1) {
            out[j++] = base64en[(in[i] & 0xF) << 2];
            out[j++] = BASE64_PAD;
        }
        
        return BASE64_OK;
    }
    
    int base64_decode(const char *in, unsigned int inlen, unsigned char *out)
    {
        unsigned int i, j;
        
        for (i = j = 0; i < inlen; i++) {
            int c;
            int s = i % 4; 			/* from 8/gcd(6, 8) */
            
            if (in[i] == '=')
                return BASE64_OK;
            
            if (in[i] < BASE64DE_FIRST || in[i] > BASE64DE_LAST ||
                (c = base64de[in[i] - BASE64DE_FIRST]) == -1)
                return BASE64_INVALID;
            
            switch (s) {
                case 0:
                    out[j] = ((unsigned int)c << 2) & 0xFF;
                    continue;
                case 1:
                    out[j++] += ((unsigned int)c >> 4) & 0x3;
                    
                    /* if not last char with padding */
                    if (i < (inlen - 3) || in[inlen - 2] != '=')
                        out[j] = ((unsigned int)c & 0xF) << 4; 
                    continue;
                case 2:
                    out[j++] += ((unsigned int)c >> 2) & 0xF;
                    
                    /* if not last char with padding */
                    if (i < (inlen - 2) || in[inlen - 1] != '=')
                        out[j] =  ((unsigned int)c & 0x3) << 6;
                    continue;
                case 3:
                    out[j++] += (unsigned char)c;
            }
        }
        
        return BASE64_OK;
    }

}
}

