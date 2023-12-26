#ifndef __LIBDARTS_H__
#define __LIBDARTS_H__

#ifdef __cplusplus
extern "C" {
#endif
  
#include <stddef.h>

/**
 Type of double array instance.
*/
typedef void* darts_t;

/**
 Type of double array trie key.
*/
typedef char darts_key_type;

/**
 Type of double array trie value.
 */
typedef long darts_value_type;

/*
 <darts_result_pair_type> enables applications to get the lengths of the
 matched keys in addition to the values.
*/
typedef struct {
  darts_value_type value;
  size_t length;
} darts_result_pair_type;

/**
 darts_new() constructs an instance of double array trie.
*/
darts_t darts_new(void);

/**
 darts_new() frees an allocated double array trie.
 */
void darts_delete(darts_t darts);

/**
 darts_error() returns the internal error. It could be NULL if there is
 no error.
*/
const char* darts_error(const darts_t darts);

/**
 Returns version string of Darts.
*/
const char* darts_version(void);

/**
 darts_set_array() calls darts_clear() in order to free memory allocated to the
 old array and then sets a new array. This function is useful to set a memory-
 mapped array.
 
 Note that the array set by darts_set_array() is not freed in
 darts_clear() and darts_delete().
 
 darts_set_array() can also set the size of the new array but the size is not
 used in search methods. So it works well even if the size is 0 or omitted.
 Remember that darts_size() and darts_total_size() returns 0 in such a case.
*/
void darts_set_array(darts_t darts,
                     const void *ptr,
                     size_t size);

/**
 darts_array() returns a pointer to the array of units.
*/
const void* darts_array(const darts_t darts);

/**
 darts_clear() frees memory allocated to units and then initializes member
 variables with 0 and NULLs. Note that darts_clear() does not free memory if
 the array of units was set by darts_clear(). In such a case, `array_' is not
 NULL and `buf_' is NULL.
*/
void darts_clear(darts_t darts);

/**
 unit_size() returns the size of each unit. The size must be 4 bytes.
*/
size_t darts_unit_size(const darts_t darts);

/**
 size() returns the number of units. It can be 0 if set_array() is used.
*/
size_t darts_size(const darts_t darts);

/**
 total_size() returns the number of bytes allocated to the array of units.
 It can be 0 if set_array() is used.
*/
size_t darts_total_size(const darts_t darts);

/**
 nonzero_size() exists for compatibility. It always returns the number of
 units because it takes long time to count the number of non-zero units.
*/
size_t darts_nonzero_size(const darts_t darts);

/**
 darts_build() constructs a dictionary from given key-value pairs. If `lengths'
 is NULL, `keys' is handled as an array of zero-terminated strings. If
 `values' is NULL, the index in `keys' is associated with each key, i.e.
 the ith key has (i - 1) as its value.
 
 Note that the key-value pairs must be arranged in key order and the values
 must not be negative. Also, if there are duplicate keys, only the first
 pair will be stored in the resultant dictionary.
 
 `progress_func' is a pointer to a callback function. If it is not NULL,
 it will be called in darts_build() so that the caller can check the progress of
 dictionary construction.
 
 The return value of darts_build() is 0, and it indicates the success of the
 operation. Otherwise, get error message from darts_error().
 
 darts_build() uses another construction algorithm if `values' is not NULL. In
 this case, Darts-clone uses a Directed Acyclic Word Graph (DAWG) instead
 of a trie because a DAWG is likely to be more compact than a trie.
*/
int darts_build(darts_t darts,
                size_t num_keys,
                const darts_key_type*const* keys,
                const size_t* lengths,
                const darts_value_type* values,
                int (*progress_func)(size_t, size_t));

/**
 darts_open() reads an array of units from the specified file. And if it goes
 well, the old array will be freed and replaced with the new array read
 from the file. `offset' specifies the number of bytes to be skipped before
 reading an array. `size' specifies the number of bytes to be read from the
 file. If the `size' is 0, the whole file will be read.
 
 darts_open() returns 0 iff the operation succeeds. Otherwise,
 get error message from darts_error().
*/
int darts_open(darts_t darts,
               const char* file_name,
               const char* mode,
               size_t offset,
               size_t size);

/**
 darts_save() writes the array of units into the specified file. `offset'
 specifies the number of bytes to be skipped before writing the array.
 darts_save() returns 0 iff the operation succeeds. Otherwise, it returns a
 non-zero value.
*/
int darts_save(const darts_t darts,
               const char* file_name,
               const char* mode,
               size_t offset);

/**
 darts_exact_match_search() tests whether the given key exists or not, and
 if it exists, its value and length are returned. Otherwise, the
 value and the length of return value are set to -1 and 0 respectively.
 
 Note that if `length' is 0, `key' is handled as a zero-terminated string.
 `node_pos' specifies the start position of matching. This argument enables
 the combination of exactMatchSearch() and traverse(). For example, if you
 want to test "xyzA", "xyzBC", and "xyzDE", you can use traverse() to get
 the node position corresponding to "xyz" and then you can use
 exactMatchSearch() to test "A", "BC", and "DE" from that position.
 
 Note that the length of `result' indicates the length from the `node_pos'.
 In the above example, the lengths are { 1, 2, 2 }, not { 4, 5, 5 }.
*/
darts_value_type darts_exact_match_search(const darts_t darts,
                                          const darts_key_type* key,
                                          size_t length,
                                          size_t node_pos);

/**
 darts_exact_match_search_pair() returns a darts_result_pair instead.
*/
darts_result_pair_type darts_exact_match_search_pair(const darts_t darts,
                                                     const darts_key_type* key,
                                                     size_t length,
                                                     size_t node_pos);

/**
 darts_common_prefix_search() searches for keys which match a prefix of the
 given string. If `length' is 0, `key' is handled as a zero-terminated string.
 The values and the lengths of at most `max_num_results' matched keys are
 stored in `results'. commonPrefixSearch() returns the number of matched
 keys. Note that the return value can be larger than `max_num_results' if
 there are more than `max_num_results' matches. If you want to get all the
 results, allocate more spaces and call commonPrefixSearch() again.
 `node_pos' works as well as in exactMatchSearch().
*/
size_t darts_common_prefix_search(const darts_t darts,
                                  const darts_key_type* key,
                                  darts_result_pair_type* results,
                                  size_t max_num_results,
                                  size_t length,
                                  size_t node_pos);

/**
 In Darts-clone, a dictionary is a deterministic finite-state automaton
 (DFA) and traverse() tests transitions on the DFA. The initial state is
 `node_pos' and traverse() chooses transitions labeled key[key_pos],
 key[key_pos + 1], ... in order. If there is not a transition labeled
 key[key_pos + i], traverse() terminates the transitions at that state and
 returns -2. Otherwise, traverse() ends without a termination and returns
 -1 or a nonnegative value, -1 indicates that the final state was not an
 accept state. When a nonnegative value is returned, it is the value
 associated with the final accept state. That is, traverse() returns the
 value associated with the given key if it exists. Note that traverse()
 updates `node_pos' and `key_pos' after each transition.
*/
darts_value_type darts_traverse(const darts_t darts,
                                const darts_key_type* key,
                                size_t* node_pos,
                                size_t* key_pos,
                                size_t length);
  
#ifdef __cplusplus
}
#endif

#endif
