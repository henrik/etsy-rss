# Etsy search RSS feeds

Ruby script that provides Atom (RSS, kind of) feeds from Etsy searches:

<http://etsy.nyh.name>

Sinatra app using Nokogiri and Builder, deployed to Heroku.


## Setup

If you want to set up a new instance on Heroku for some reason, it goes something like this:

* Clone this repo.
* `heroku create some-name`
* `heroku addons:add memcachier  # free`
* `git push heroku`


## Credits and license

By [Henrik Nyh](http://henrik.nyh.se/) under the MIT license:

>  Copyright (c) 2012 Henrik Nyh
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
