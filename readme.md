### HTTP **Proxy** for Testing and Development

To avoid fetching URLs from clients' sites, this proxy was written, in Haskell, to fetch arbitrary pages regardless of the URL. Configure Proxy as an HTTP proxy and it'll randomly fetch pages from a set currently defined with the source code. Moreover, it caches responses and in general fetches pages once using the cache thereafter.

### Building Proxy

To compile the code, the following prerequisite is required:

1. haskell stack: http://docs.haskellstack.org/en/stable/README/
   * install stack

2. run the following:
   1. stack setup
   2. stack build
   3. stack exec proxy

If on Ubuntu 15.10, you may also use the Makefile. Type "make" to see its targets.

NB: the Makefile is known to work on Ubuntu 15.10