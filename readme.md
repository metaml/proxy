### "HTTP" Proxy for Testing and Development

To avoid fetching URLs from clients' sites, "HTTP" Proxy was written, in Haskell, to fetch an arbitrary page regardless of a URL. Configure your code to use Proxy as an HTTP proxy. Said proxy randomly fetches pages from a set of URLs currently defined within the source code. Moreover, it caches responses and in general fetches a new URL once and thereafter uses its cache.

### Building Proxy

To compile the code, the following prerequisite is required:

1. haskell stack: http://docs.haskellstack.org/en/stable/README/
   * install **stack**

Use **stack** to build the code:

1. stack setup
2. stack build
3. stack exec proxy

If on Ubuntu 15.10, you may also use the Makefile. Type "make" to see its targets.

NB: the Makefile is known to work on Ubuntu 15.10
