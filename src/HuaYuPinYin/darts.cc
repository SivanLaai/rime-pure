#include "darts.h"
#include "darts.hh"

using namespace Darts;

struct DoubleArrayTrie {
  DoubleArray* da;
  const char* err;
  
  DoubleArrayTrie() : da(new DoubleArray()), err(NULL) {}
  ~DoubleArrayTrie() {
    delete da;
  }
};

darts_t darts_new(void) {
  return new DoubleArrayTrie();
}

void darts_delete(darts_t darts) {
  DoubleArrayTrie* inst = (DoubleArrayTrie*) darts;
  delete inst;
}

const char* darts_error(const darts_t darts) {
  const DoubleArrayTrie* inst = (const DoubleArrayTrie*) darts;
  return inst->err;
}

const char* darts_version(void) {
  return DARTS_VERSION;
}

void darts_set_array(darts_t darts,
                     const void *ptr,
                     size_t size) {
  DoubleArrayTrie* inst = (DoubleArrayTrie*) darts;
  inst->da->set_array(ptr, size);
}

const void* darts_array(const darts_t darts) {
  const DoubleArrayTrie* inst = (const DoubleArrayTrie*) darts;
  return inst->da->array();
}

void darts_clear(darts_t darts) {
  DoubleArrayTrie* inst = (DoubleArrayTrie*) darts;
  inst->da->clear();
}

size_t darts_unit_size(const darts_t darts) {
  const DoubleArrayTrie* inst = (const DoubleArrayTrie*) darts;
  return inst->da->unit_size();
}

size_t darts_size(const darts_t darts) {
  const DoubleArrayTrie* inst = (const DoubleArrayTrie*) darts;
  return inst->da->size();
}

size_t darts_total_size(const darts_t darts) {
  const DoubleArrayTrie* inst = (const DoubleArrayTrie*) darts;
  return inst->da->total_size();
}

size_t darts_nonzero_size(const darts_t darts) {
  const DoubleArrayTrie* inst = (const DoubleArrayTrie*) darts;
  return inst->da->nonzero_size();
}

int darts_build(darts_t darts,
                size_t num_keys,
                const darts_key_type*const* keys,
                const size_t* lengths,
                const darts_value_type* values,
                int (*progress_func)(size_t, size_t)) {
  DoubleArrayTrie* inst = (DoubleArrayTrie*) darts;
  try {
    return inst->da->build(num_keys, keys, lengths, values, progress_func);
  } catch (Details::Exception e) {
    inst->err = e.what();
    return -1;
  }
}

int darts_open(darts_t darts,
               const char* file_name,
               const char* mode,
               size_t offset,
               size_t size) {
  DoubleArrayTrie* inst = (DoubleArrayTrie*) darts;
  try {
    return inst->da->open(file_name, mode, offset, size);
  } catch (Details::Exception e) {
    inst->err = e.what();
    return -1;
  }
}

int darts_save(const darts_t darts,
               const char* file_name,
               const char* mode,
               size_t offset) {
  DoubleArrayTrie* inst = (DoubleArrayTrie*) darts;
  int retval = inst->da->save(file_name, mode, offset);
  if (retval != 0) {
    inst->err = "Error saving file.";
  }
  return retval;
}

darts_value_type darts_exact_match_search(const darts_t darts,
                                          const darts_key_type* key,
                                          size_t length,
                                          size_t node_pos) {
  const DoubleArrayTrie* inst = (const DoubleArrayTrie*) darts;
  return inst->da->exactMatchSearch<darts_value_type>(key, length, node_pos);
}

darts_result_pair_type darts_exact_match_search_pair(const darts_t darts,
                                                     const darts_key_type* key,
                                                     size_t length,
                                                     size_t node_pos) {
  const DoubleArrayTrie* inst = (const DoubleArrayTrie*) darts;
  DoubleArray::result_pair_type result_tmp =
    inst->da->exactMatchSearch<DoubleArray::result_pair_type>(key,
                                                              length,
                                                              node_pos);
  darts_result_pair_type result;
  result.value = result_tmp.value;
  result.length = result_tmp.length;
  return result;
}

size_t darts_common_prefix_search(const darts_t darts,
                                  const darts_key_type* key,
                                  darts_result_pair_type* results,
                                  size_t max_num_results,
                                  size_t length,
                                  size_t node_pos) {
  const DoubleArrayTrie* inst = (const DoubleArrayTrie*) darts;
  return inst->da->commonPrefixSearch(key,
                                      (DoubleArray::result_pair_type*)results,
                                      max_num_results,
                                      length,
                                      node_pos);
}

darts_value_type darts_traverse(const darts_t darts,
                                const darts_key_type* key,
                                size_t* node_pos,
                                size_t* key_pos,
                                size_t length) {
  const DoubleArrayTrie* inst = (const DoubleArrayTrie*) darts;
  return inst->da->traverse(key, *node_pos, *key_pos, length);
}
