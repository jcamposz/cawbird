
bool is_desc_sorted (Cb.TweetModel tm) {
  int64 last_id = ((Cb.Tweet)tm.get_item (0)).id;

  for (int i = 1; i < tm.get_n_items (); i ++) {
    Cb.Tweet t = (Cb.Tweet)tm.get_item (i);
    if (t.id > last_id) return false;

    last_id = t.id;
  }
  return true;
}

bool is_thread_mode_sorted (Cb.TweetModel tm) {
  Cb.Tweet first_tweet = ((Cb.Tweet)tm.get_item (0));
  int64 last_id = first_tweet.retweeted_tweet == null ? first_tweet.id : first_tweet.retweeted_tweet.id;

  for (int i = 1; i < tm.get_n_items (); i ++) {
    Cb.Tweet t = (Cb.Tweet)tm.get_item (i);
    int64 id = t.retweeted_tweet == null ? t.id : t.retweeted_tweet.id;
    debug("ID: %lld", id);

    if (id < last_id) return false;

    last_id = id;
  }
  return true;
}

int64 get_max_id (Cb.TweetModel tm) {
  int64 max = -1;

  for (int i = 0; i < tm.get_n_items (); i ++) {
    var t = (Cb.Tweet)tm.get_item (i);
    if (t.id > max) max = t.id;
  }

  return max;
}

void basic_tweet_order () {
  Cb.TweetModel tm = new Cb.TweetModel ();

  Cb.Tweet t1 = new Cb.Tweet ();
  t1.id = 10;

  Cb.Tweet t2 = new Cb.Tweet ();
  t2.id = 100;

  Cb.Tweet t3 = new Cb.Tweet ();
  t3.id = 1000;


  tm.add (t3); // 1000
  assert (tm.min_id == 1000);
  assert (tm.max_id == 1000);
  tm.add (t1); // 10
  assert (tm.min_id == 10);
  assert (tm.max_id == 1000);
  tm.add (t2); // 100
  assert (tm.min_id == 10);
  assert (tm.max_id == 1000);

  assert (tm.get_n_items () == 3);
  assert (is_desc_sorted (tm));

  assert (((Cb.Tweet)tm.get_item (0)).id == 1000);
  assert (((Cb.Tweet)tm.get_item (1)).id == 100);
  assert (((Cb.Tweet)tm.get_item (2)).id == 10);
}

void basic_tweet_order_thread_mode () {
  Cb.TweetModel tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  Cb.Tweet t1 = new Cb.Tweet ();
  t1.id = 10;

  Cb.Tweet t2 = new Cb.Tweet ();
  t2.id = 100;

  Cb.Tweet t3 = new Cb.Tweet ();
  t3.id = 1000;


  tm.add (t3); // 1000
  assert (tm.min_id == 1000);
  assert (tm.max_id == 1000);
  tm.add (t1); // 10
  assert (tm.min_id == 10);
  assert (tm.max_id == 1000);
  tm.add (t2); // 100
  assert (tm.min_id == 10);
  assert (tm.max_id == 1000);

  assert (tm.get_n_items () == 3);

  assert (is_thread_mode_sorted (tm));

  assert (((Cb.Tweet)tm.get_item (0)).id == 10);
  assert (((Cb.Tweet)tm.get_item (1)).id == 100);
  assert (((Cb.Tweet)tm.get_item (2)).id == 1000);
}

void retweet_order () {
  Cb.TweetModel tm = new Cb.TweetModel ();

  Cb.Tweet t1 = new Cb.Tweet ();
  t1.id = 10;

  Cb.Tweet t2 = new Cb.Tweet ();
  t2.id = 100;
  t2.retweeted_tweet = Cb.MiniTweet ();
  t2.retweeted_tweet.id = 5;

  Cb.Tweet t3 = new Cb.Tweet ();
  t3.id = 1000;


  tm.add (t3); // 1000
  assert (tm.min_id == 1000);
  assert (tm.max_id == 1000);
  tm.add (t1); // 10
  assert (tm.min_id == 10);
  assert (tm.max_id == 1000);
  tm.add (t2); // 100
  assert (tm.min_id == 10);
  assert (tm.max_id == 1000);

  assert (tm.get_n_items () == 3);
  assert (is_desc_sorted (tm));

  assert (((Cb.Tweet)tm.get_item (0)).id == 1000);
  assert (((Cb.Tweet)tm.get_item (1)).id == 100);
  assert (((Cb.Tweet)tm.get_item (2)).id == 10);
}

void retweet_order_thread_mode () {
  Cb.TweetModel tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  Cb.Tweet t1 = new Cb.Tweet ();
  t1.id = 10;

  Cb.Tweet t2 = new Cb.Tweet ();
  t2.id = 100;
  t2.retweeted_tweet = Cb.MiniTweet ();
  t2.retweeted_tweet.id = 5;

  Cb.Tweet t3 = new Cb.Tweet ();
  t3.id = 1000;


  tm.add (t3); // 1000
  assert (tm.min_id == 1000);
  assert (tm.max_id == 1000);
  tm.add (t1); // 10
  assert (tm.min_id == 10);
  assert (tm.max_id == 1000);
  tm.add (t2); // 100 RTing 5
  assert (tm.min_id == 5);
  assert (tm.max_id == 1000);

  assert (tm.get_n_items () == 3);

  assert (is_thread_mode_sorted (tm));

  // ID order looks odd because of the RT being moved to the top
  assert (((Cb.Tweet)tm.get_item (0)).id == 100);
  assert (((Cb.Tweet)tm.get_item (1)).id == 10);
  assert (((Cb.Tweet)tm.get_item (2)).id == 1000);
}

void retweet_duplicate_insertion () {
  Cb.TweetModel tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  Cb.Tweet t1 = new Cb.Tweet ();
  t1.id = 10;

  Cb.Tweet t2 = new Cb.Tweet ();
  t2.id = 100;
  t2.retweeted_tweet = Cb.MiniTweet ();
  t2.retweeted_tweet.id = 10;

  tm.add(t1);
  tm.add(t2);
  assert(tm.get_n_items() == 1);
}

void tweet_removal () {
  var tm = new Cb.TweetModel ();

  //add 10 visible tweets
  for (int i = 0; i < 10; i ++) {
    var t = new Cb.Tweet ();
    t.id = 100 - i;
    tm.add (t);
  }

  // now add 2 invisible tweets
  {
    var t = new Cb.Tweet ();
    t.id = 2;
    t.set_flag (Cb.TweetState.HIDDEN_FORCE);
    tm.add (t);

    assert (tm.get_n_items () == 10);

    t = new Cb.Tweet ();
    t.id = 1;
    t.set_flag (Cb.TweetState.HIDDEN_UNFOLLOWED);
    tm.add (t);

    assert (tm.get_n_items () == 10);
  }

  // We should have 10 now
  assert (tm.get_n_items () == 10);
  // And two hidden tweets
  assert (tm.hidden_tweets.length == 2);

  // Now remove the last 5 visible ones.
  // This should remove 2 invisible tweets as well as 5 visible ones
  // Leaving the model with 5 remaining tweets
  tm.remove_oldest_n_visible (5);

  assert (tm.get_n_items () == 5);
  assert (tm.hidden_tweets.length == 0);

  for (int i = 0; i < 5; i++) {
    debug("%lld", ((Cb.Tweet)tm.get_item (0)).id);
    assert (((Cb.Tweet)tm.get_item (i)).id == 100 - i);
  }
}

void tweet_removal_thread_mode () {
  var tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  //add 10 visible tweets
  for (int i = 0; i < 10; i ++) {
    var t = new Cb.Tweet ();
    t.id = 100 - i;
    tm.add (t);
  }

  // now add 2 invisible tweets
  {
    var t = new Cb.Tweet ();
    t.id = 2;
    t.set_flag (Cb.TweetState.HIDDEN_FORCE);
    tm.add (t);

    assert (tm.get_n_items () == 10);

    t = new Cb.Tweet ();
    t.id = 1;
    t.set_flag (Cb.TweetState.HIDDEN_UNFOLLOWED);
    tm.add (t);

    assert (tm.get_n_items () == 10);
  }

  // We should have 10 now
  assert (tm.get_n_items () == 10);
  // And two hidden tweets
  assert (tm.hidden_tweets.length == 2);

  // Now remove the last 5 visible ones.
  // This should remove 2 invisible tweets as well as 5 visible ones
  // Leaving the model with 5 remaining tweets
  tm.remove_oldest_n_visible (5);

  assert (tm.get_n_items () == 5);
  assert (tm.hidden_tweets.length == 0);

  for (int i = 0; i < 5; i++) {
    debug("%lld", ((Cb.Tweet)tm.get_item (0)).id);
    assert (((Cb.Tweet)tm.get_item (i)).id == 96 + i);
  }
}

void tweet_removal_zero_length_handling () {
  var tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  for (int i = 0; i < 20; i ++) {
    var t = new Cb.Tweet();
    t.id = 10 + (i * 2); // Only even ids
    tm.add (t);
  }

  tm.remove_oldest_n_visible (0);
}


void contains () {
  var tm = new Cb.TweetModel ();

  const int n = 10;

  for (int i = 0; i < n; i++) {
    var t = new Cb.Tweet ();
    t.id = 100 + i;

    tm.add (t);
  }

  for (int i = 0; i < n; i++) {
    assert (tm.contains_id (100 + i));
  }

  assert (!tm.contains_id (99));
  assert (!tm.contains_id (100 + n));
}

void index_of () {
  var tm = new Cb.TweetModel ();

  const int n = 10;

  for (int i = 0; i < n; i++) {
    var t = new Cb.Tweet ();
    t.id = 100 + i;

    tm.add (t);
  }

  for (int i = 0; i < n; i++) {
    assert (tm.index_of (100 + i) == n - i - 1);
  }

  assert (tm.index_of (99) == -1);
  assert (tm.index_of (100 + n) == -1);
}

void index_of_thread_mode () {
  var tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  const int n = 10;

  for (int i = 0; i < n; i++) {
    var t = new Cb.Tweet ();
    t.id = 100 + i;

    tm.add (t);
  }

  for (int i = 0; i < n; i++) {
    assert (tm.index_of (100 + i) == i);
  }

  assert (tm.index_of (99) == -1);
  assert (tm.index_of (100 + n) == -1);
}

void index_of_rt () {
  var tm = new Cb.TweetModel ();

  const int n = 10;

  for (int i = 0; i < n; i++) {
    var t = new Cb.Tweet ();
    t.id = 100 + i;
    t.retweeted_tweet = Cb.MiniTweet();
    t.retweeted_tweet.id = 10 + i;

    tm.add (t);
  }

  for (int i = 0; i < n; i++) {
    assert (tm.index_of_retweet (10 + i) == n - i - 1);
  }

  assert (tm.index_of_retweet (9) == -1);
  assert (tm.index_of_retweet (10 + n) == -1);
}

void index_of_rt_thread_mode () {
  var tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  const int n = 10;

  for (int i = 0; i < n; i++) {
    var t = new Cb.Tweet ();
    t.id = 100 + i;
    t.retweeted_tweet = Cb.MiniTweet();
    t.retweeted_tweet.id = 10 + i;

    tm.add (t);
  }

  for (int i = 0; i < n; i++) {
    assert (tm.index_of_retweet (10 + i) == i);
  }

  assert (tm.index_of_retweet (9) == -1);
  assert (tm.index_of_retweet (10 + n) == -1);
}

void clear () {
  var tm = new Cb.TweetModel ();

  const int n = 10;

  for (int i = 0; i < n; i++) {
    var t = new Cb.Tweet ();
    t.id = 100 + i;

    tm.add (t);
  }

  assert (tm.get_n_items () == n);

  tm.clear ();
  assert (tm.get_n_items () == 0);
}

void clear2 () {
  var tm1 = new Cb.TweetModel ();
  var tm2 = new Cb.TweetModel ();

  var t = new Cb.Tweet ();
  t.id = 10000;
  tm1.add (t);

  var t2 = new Cb.Tweet ();
  t2.id = 3400;
  t2.set_flag (Cb.TweetState.HIDDEN_FORCE);
  tm1.add(t2);

  tm1.clear ();

  assert (tm1.get_n_items () == tm2.get_n_items ());
  assert (tm1.max_id == tm2.max_id);
  assert (tm1.min_id == tm2.min_id);
  assert (tm1.hidden_tweets.length == 0);
}

void remove_tweet () {
  var tm = new Cb.TweetModel ();

  var t1 = new Cb.Tweet ();
  t1.id = 10;
  tm.add (t1);

  var t2 = new Cb.Tweet ();
  t2.id = 100;
  tm.add (t2);

  assert (tm.get_n_items () == 2);

  tm.remove_tweet (t2);

  assert (tm.get_n_items () == 1);

  tm.remove_tweet (t1);

  assert (tm.get_n_items () == 0);
}

void remove_hidden () {
  var tm = new Cb.TweetModel ();

  var t1 = new Cb.Tweet ();
  t1.id = 10;
  t1.set_flag (Cb.TweetState.HIDDEN_UNFOLLOWED);
  tm.add (t1);

  assert (tm.get_n_items () == 0);
  assert (tm.hidden_tweets.length == 1);

  tm.remove_tweet (t1);
  assert (tm.get_n_items () == 0);
  assert (tm.hidden_tweets.length == 0);
}

void remove_older () {
  var tm = new Cb.TweetModel ();

  for (int i = 1; i < 51; i ++) {
    var t = new Cb.Tweet ();
    t.id = i;
    tm.add (t);
  }

  assert (tm.get_n_items () == 50);
  tm.remove_tweets_later_than (25);
  debug("%u", tm.get_n_items ());
  assert (tm.get_n_items () == 24);
  assert (tm.max_id == 24);
  assert (tm.min_id == 1);
}

void remove_older_thread_mode () {
  var tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  for (int i = 1; i < 51; i ++) {
    var t = new Cb.Tweet ();
    t.id = i;
    tm.add (t);
  }

  assert (tm.get_n_items () == 50);
  tm.remove_tweets_later_than (25);
  assert (tm.get_n_items () == 24);
  assert (tm.max_id == 24);
  assert (tm.min_id == 1);
}

void remove_own_retweet () {
  var tm = new Cb.TweetModel ();

  var t1 = new Cb.Tweet ();
  t1.id = 1337;
  t1.my_retweet = 500; // <--
  t1.set_flag (Cb.TweetState.RETWEETED);

  tm.add (t1);

  for (int i = 1; i < 51; i ++) {
    var t = new Cb.Tweet ();
    t.id = i;
    tm.add (t);
  }

  assert (tm.get_n_items () == 51);

  //tm.remove (5);
  //assert (tm.get_n_items () == 50);

  // should not actually remove any tweet
  tm.remove_tweet (t1);
  assert (tm.get_n_items () == 50);
}

void hide_rt () {
  var tm = new Cb.TweetModel ();

  var t1 = new Cb.Tweet ();
  t1.id = 100;
  t1.source_tweet = Cb.MiniTweet ();
  t1.source_tweet.author = Cb.UserIdentity ();
  t1.source_tweet.author.id = 10;
  t1.source_tweet.id = 1;
  t1.retweeted_tweet = Cb.MiniTweet ();
  t1.retweeted_tweet.id = 100;
  t1.retweeted_tweet.author = Cb.UserIdentity ();
  t1.retweeted_tweet.author.id = 100;

  tm.add (t1);
  //assert (!t1.is_hidden ());

  //tm.toggle_flag_on_user_retweets (10, Cb.TweetState.HIDDEN_FILTERED, true);
  //assert (t1.is_hidden ());

  //assert (tm.get_n_items () == 0);
  //assert (tm.hidden_tweets.length == 1);

  //tm.toggle_flag_on_user_retweets (10, Cb.TweetState.HIDDEN_FILTERED, false);
  //assert (!t1.is_hidden ());
  //assert (tm.get_n_items () == 1);
  //assert (!((Cb.Tweet)tm.get_item (0)).is_hidden ());
}

void get_for_id () {
  var tm = new Cb.TweetModel ();

  var t1 = new Cb.Tweet ();
  t1.id = 10;

  var t2 = new Cb.Tweet ();
  t2.id = 100;

  tm.add (t1);
  tm.add (t2);

  assert (tm.get_n_items () == 2);
  assert (((Cb.Tweet)tm.get_item (0)).id == 100);
  assert (((Cb.Tweet)tm.get_item (1)).id == 10);

  var result = tm.get_for_id (10);
  assert (result != null);
  assert (result.id == 10);

  var t3 = new Cb.Tweet ();
  t3.id = 1000;
  tm.add (t3);

  result = tm.get_for_id (100, 1);

  assert (result != null);
  assert (result.id == 10);

  result = tm.get_for_id (100, -1);

  assert (result != null);
  assert (result.id == 1000);
}

void get_for_id_thread_mode () {
  var tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  var t1 = new Cb.Tweet ();
  t1.id = 10;

  var t2 = new Cb.Tweet ();
  t2.id = 100;

  tm.add (t1);
  tm.add (t2);

  assert (tm.get_n_items () == 2);
  assert (((Cb.Tweet)tm.get_item (0)).id == 10);
  assert (((Cb.Tweet)tm.get_item (1)).id == 100);

  var result = tm.get_for_id (10);
  assert (result != null);
  assert (result.id == 10);

  var t3 = new Cb.Tweet ();
  t3.id = 1000;
  tm.add (t3);

  result = tm.get_for_id (100, 1);

  assert (result != null);
  assert (result.id == 1000);

  result = tm.get_for_id (100, -1);

  assert (result != null);
  assert (result.id == 10);
}

void min_max_id () {
  var tm = new Cb.TweetModel ();
  var t = new Cb.Tweet ();
  t.id = 1337;
  tm.add (t);

  var t2 = new Cb.Tweet ();
  t2.id = 30000;
  t2.set_flag (Cb.TweetState.HIDDEN_FORCE);
  tm.add (t2); // Hidden tweets shouldn't affect the min/max id values

  assert (tm.min_id == 1337);
  assert (tm.max_id == 1337);

  var t3 = new Cb.Tweet ();
  t3.id = 1400;
  tm.add (t3);

  var t4 = new Cb.Tweet ();
  t4.id = 1300;
  tm.add (t4);

  assert (tm.min_id == 1300);
  assert (tm.max_id == 1400);
}

void min_max_id_thread_mode () {
  var tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);
  var t = new Cb.Tweet ();
  t.id = 1337;
  tm.add (t);

  var t2 = new Cb.Tweet ();
  t2.id = 30000;
  t2.set_flag (Cb.TweetState.HIDDEN_FORCE);
  tm.add (t2); // Hidden tweets shouldn't affect the min/max id values

  assert (tm.min_id == 1337);
  assert (tm.max_id == 1337);

  var t3 = new Cb.Tweet ();
  t3.id = 1400;
  tm.add (t3);

  var t4 = new Cb.Tweet ();
  t4.id = 1300;
  tm.add (t4);

  assert (tm.min_id == 1300);
  assert (tm.max_id == 1400);
}


void sorting () {
  var tm = new Cb.TweetModel ();

  for (int i = 0; i < 100; i ++) {
    var t = new Cb.Tweet ();
    t.id = GLib.Random.next_int ();
    tm.add (t);
  }

  assert (is_desc_sorted (tm));

  tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  for (int i = 0; i < 100; i ++) {
    var t = new Cb.Tweet ();
    t.id = GLib.Random.next_int ();
    tm.add (t);
  }

  assert (is_thread_mode_sorted (tm));
}

void min_max_remove () {
  var tm = new Cb.TweetModel ();

  var t1 = new Cb.Tweet ();
  t1.id = 10;
  tm.add (t1);

  var t2 = new Cb.Tweet ();
  t2.id = 20;
  tm.add (t2);

  var t3 = new Cb.Tweet ();
  t3.id = 2;
  tm.add (t3);

  assert (tm.max_id == 20);
  assert (tm.min_id == 2);

  tm.remove_tweet (t1);
  // Should still be the same
  assert (tm.max_id == 20);
  assert (tm.min_id == 2);

  var t = new Cb.Tweet ();
  t.id = 10;
  tm.add (t);

  // And again...
  assert (tm.max_id == 20);
  assert (tm.min_id == 2);


  // Now it gets interesting
  tm.remove_tweet (t2);
  assert (tm.min_id == 2);
  assert (tm.max_id == 10);
  assert (tm.max_id == get_max_id (tm));

  tm.remove_tweet (t3);
  assert (tm.min_id == 10);
  assert (tm.max_id == 10);

  tm.remove_tweet (t);
  assert (tm.get_n_items () == 0);
  assert (tm.min_id == int64.MAX);
  assert (tm.max_id == int64.MIN);
}

void min_max_remove_thread_mode () {
  var tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  var t1 = new Cb.Tweet ();
  t1.id = 10;
  tm.add (t1);

  var t2 = new Cb.Tweet ();
  t2.id = 20;
  tm.add (t2);

  var t3 = new Cb.Tweet ();
  t3.id = 2;
  tm.add (t3);

  assert (tm.max_id == 20);
  assert (tm.min_id == 2);

  tm.remove_tweet (t1);
  // Should still be the same
  assert (tm.max_id == 20);
  assert (tm.min_id == 2);

  var t = new Cb.Tweet ();
  t.id = 10;
  tm.add (t);

  // And again...
  assert (tm.max_id == 20);
  assert (tm.min_id == 2);


  // Now it gets interesting
  tm.remove_tweet (t2);
  assert (tm.min_id == 2);
  assert (tm.max_id == 10);
  assert (tm.max_id == get_max_id (tm));

  tm.remove_tweet (t3);
  assert (tm.min_id == 10);
  assert (tm.max_id == 10);

  tm.remove_tweet (t);
  assert (tm.get_n_items () == 0);
  assert (tm.min_id == int64.MAX);
  assert (tm.max_id == int64.MIN);
}

void tweet_count () {
  var tm = new Cb.TweetModel ();

  var t1 = new Cb.Tweet ();
  t1.id = 10;
  t1.source_tweet = Cb.MiniTweet ();
  t1.source_tweet.author = Cb.UserIdentity ();
  t1.source_tweet.author.id = 11;
  t1.retweeted_tweet = Cb.MiniTweet ();
  t1.retweeted_tweet.id = 100;
  t1.retweeted_tweet.author = Cb.UserIdentity ();
  t1.retweeted_tweet.author.id = 111;

  tm.add (t1);
  assert (tm.get_n_items () == 1);
  assert (tm.max_id == t1.id);
  assert (tm.min_id == t1.id);

  tm.toggle_flag_on_user_retweets (11, Cb.TweetState.HIDDEN_FILTERED, true);
  assert (tm.get_n_items () == 0);
  assert (tm.hidden_tweets.length == 0);

  t1.unset_flag (Cb.TweetState.HIDDEN_FILTERED);

  var t2 = new Cb.Tweet ();
  t2.id = 20;
  t2.source_tweet = Cb.MiniTweet ();
  t2.source_tweet.author = Cb.UserIdentity ();
  t2.source_tweet.author.id = 11;

  tm.add (t2);
  tm.add (t1);
  assert (tm.get_n_items () == 2);
  assert (tm.max_id == t2.id);
  assert (tm.min_id == t1.id);

  tm.toggle_flag_on_user_tweets (11, Cb.TweetState.HIDDEN_FILTERED, true);
  assert (tm.get_n_items () == 1);
  tm.toggle_flag_on_user_retweets (11, Cb.TweetState.HIDDEN_FILTERED, true);
  assert (tm.get_n_items () == 0);

  assert (tm.hidden_tweets.length == 0);
}

void hidden_remove_oldest_n_visible () {
  var tm = new Cb.TweetModel ();

  for (int i = 0; i < 20; i ++) {
    var t = new Cb.Tweet();
    t.id = 10 + (i * 2); // Only even ids
    tm.add (t);
  }

  var t1 = new Cb.Tweet ();
  t1.id = 15;
  t1.set_flag (Cb.TweetState.HIDDEN_UNFOLLOWED);
  tm.add (t1);

  var t2 = new Cb.Tweet ();
  t2.id = 21;
  t2.set_flag (Cb.TweetState.HIDDEN_AUTHOR_MUTED);
  tm.add (t2);

  assert (tm.get_n_items () == 20);
  assert (tm.hidden_tweets.length == 2);

  tm.remove_oldest_n_visible (10);
  assert (tm.get_n_items () == 10);
  for (int i = 0; i < 10; i ++) {
    assert (((Cb.Tweet)tm.get_item (i)).id >= 30);
  }
  tm.remove_oldest_n_visible (10);
  assert (tm.get_n_items () == 0);
}

void hidden_remove_oldest_n_visible_thread_mode () {
  var tm = new Cb.TweetModel ();
  tm.set_thread_mode (true);

  for (int i = 0; i < 20; i ++) {
    var t = new Cb.Tweet();
    t.id = 10 + (i * 2); // Only even ids
    tm.add (t);
  }

  var t1 = new Cb.Tweet ();
  t1.id = 15;
  t1.set_flag (Cb.TweetState.HIDDEN_UNFOLLOWED);
  tm.add (t1);

  var t2 = new Cb.Tweet ();
  t2.id = 21;
  t2.set_flag (Cb.TweetState.HIDDEN_AUTHOR_MUTED);
  tm.add (t2);

  assert (tm.get_n_items () == 20);
  assert (tm.hidden_tweets.length == 2);

  tm.remove_oldest_n_visible (10);
  assert (tm.get_n_items () == 10);
  for (int i = 0; i < 10; i ++) {
    debug("%lld", ((Cb.Tweet)tm.get_item (i)).id);
    assert (((Cb.Tweet)tm.get_item (i)).id >= 30);
  }

  tm.remove_oldest_n_visible (10);
  assert (tm.get_n_items () == 0);
}

void empty_hidden_tweets () {
  int n = 100;
  var tm = new Cb.TweetModel ();
  for (int i = 1; i <= n; i += 2) {
    var t1 = new Cb.Tweet ();
    t1.id = i + 1;
    tm.add (t1);

    var t2 = new Cb.Tweet ();
    t2.id = i;
    t2.set_flag (Cb.TweetState.HIDDEN_RT_BY_FOLLOWEE);
    tm.add (t2);

    tm.remove_tweet (t1);
  }

  message ("%u", tm.get_n_items ());
  assert (tm.get_n_items () == 0);
  message ("%u", tm.hidden_tweets.length);
  assert (tm.hidden_tweets.length == 0);
}

void same_id () {
  var tm = new Cb.TweetModel ();
  var t = new Cb.Tweet ();
  t.id = 1337;

  tm.add (t);
  assert (tm.get_n_items () == 1);
  assert (tm.min_id == 1337);
  assert (tm.max_id == 1337);

  tm.add (t);
  /* No change */
  assert (tm.get_n_items () == 1);
  assert (tm.min_id == 1337);
  assert (tm.max_id == 1337);

  // What if we created it from a different source?
  var t2 = new Cb.Tweet ();
  t2.id = t.id;
  tm.add (t2);
  assert (tm.get_n_items () == 1);
  assert (tm.min_id == 1337);
  assert (tm.max_id == 1337);
}

int main (string[] args) {
  GLib.Test.init (ref args);
  GLib.Test.add_func ("/tweetmodel/basic-tweet-order", basic_tweet_order);
  GLib.Test.add_func ("/tweetmodel/basic-tweet-order-thread-mode", basic_tweet_order_thread_mode);
  GLib.Test.add_func ("/tweetmodel/retweet-order", retweet_order);
  GLib.Test.add_func ("/tweetmodel/retweet-order-thread-mode", retweet_order_thread_mode);
  GLib.Test.add_func ("/tweetmodel/retweet-duplicate-insertion", retweet_duplicate_insertion);
  GLib.Test.add_func ("/tweetmodel/tweet-removal", tweet_removal);
  GLib.Test.add_func ("/tweetmodel/tweet-removal-thread-mode", tweet_removal_thread_mode);
  GLib.Test.add_func ("/tweetmodel/tweet-removal-zero-length", tweet_removal_zero_length_handling);
  GLib.Test.add_func ("/tweetmodel/contains", contains);
  GLib.Test.add_func ("/tweetmodel/index-of", index_of);
  GLib.Test.add_func ("/tweetmodel/index-of-thread-mode", index_of_thread_mode);
  GLib.Test.add_func ("/tweetmodel/index-of-retweet", index_of_rt);
  GLib.Test.add_func ("/tweetmodel/index-of-retweet-thread-mode", index_of_rt_thread_mode);
  GLib.Test.add_func ("/tweetmodel/clear", clear);
  GLib.Test.add_func ("/tweetmodel/clear2", clear2);
  GLib.Test.add_func ("/tweetmodel/remove", remove_tweet);
  GLib.Test.add_func ("/tweetmodel/remove-hidden", remove_hidden);
  GLib.Test.add_func ("/tweetmodel/remove-own-retweet", remove_own_retweet);
  GLib.Test.add_func ("/tweetmodel/remove-older", remove_older);
  GLib.Test.add_func ("/tweetmodel/remove-older-thread-mode", remove_older_thread_mode);
  GLib.Test.add_func ("/tweetmodel/hide-rt", hide_rt);
  GLib.Test.add_func ("/tweetmodel/get-for-id", get_for_id);
  GLib.Test.add_func ("/tweetmodel/get-for-id-thread-mode", get_for_id_thread_mode);
  GLib.Test.add_func ("/tweetmodel/min-max-id", min_max_id);
  GLib.Test.add_func ("/tweetmodel/min-max-id-thread-mode", min_max_id_thread_mode);
  GLib.Test.add_func ("/tweetmodel/sorting", sorting);
  GLib.Test.add_func ("/tweetmodel/min-max-remove", min_max_remove);
  GLib.Test.add_func ("/tweetmodel/min-max-remove-thread-mode", min_max_remove_thread_mode);
  GLib.Test.add_func ("/tweetmodel/tweet-count", tweet_count);
  GLib.Test.add_func ("/tweetmodel/empty-hidden-tweets", empty_hidden_tweets);
  GLib.Test.add_func ("/tweetmodel/hidden-remove-last-n-visible", hidden_remove_oldest_n_visible);
  GLib.Test.add_func ("/tweetmodel/hidden-remove-last-n-visible-thread-mode", hidden_remove_oldest_n_visible_thread_mode);
  GLib.Test.add_func ("/tweetmodel/same-id", same_id);

  return GLib.Test.run ();
}
