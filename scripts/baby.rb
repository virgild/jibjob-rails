require 'bundler'
Bundler.setup
require 'active_support'
require 'capybara'
require 'capybara/poltergeist'
require 'timeout'
require 'faker'
require 'thread'

Capybara.configure do |config|
  config.javascript_driver = :poltergeist
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    :js_errors => false,
    :phantomjs_options => ["--ignore-ssl-errors=yes", "--local-to-remote-url-access=true"],
    :window_size => [1024, 768],
    :timeout => 60,
    :debug => (ENV['DEBUG'] == '1')
  })
end

class BrowserSession
  def initialize(opts = {})
    @options = opts
    @browser = Capybara::Session.new(:poltergeist)
    set_host(@options.delete(:host))
  end

  def browser
    @browser
  end

  def host
    @host
  end

  def set_host(url)
    @host = url
  end

  def wait_for(&blk)
    begin
      Timeout.timeout(16) do
        sleep(0.1) until blk.call
      end
    rescue TimeoutError => error
      error.set_backtrace(error.backtrace - error.backtrace[0..3])
      raise error
    end
  end

  def wait_for_selector(selector)
    wait_for do
      page_has_selector?(selector)
    end
  end

  def clear_cookies!
    browser.driver.cookies.keys.each { |cookie| browser.driver.remove_cookie(cookie) }
  end

  def visit(path)
    url = "#{host}#{path}"
    browser.visit(url)
  end

  def select_value(dropdown, value)
    browser.within(dropdown) do
      browser.find("option[value='#{value}']").select_option
    end
  end

  def perform_when_present(selector, &blk)
    if browser.all(selector).count > 0
      blk.call
    end
  end

  def save_screenshot(file)
    browser.driver.save_screenshot(file, :full => true)
  end

  def wait_for_ajax
    counter = 0
    while browser.execute_script("return $.active").to_i > 0
      counter += 1
      sleep(0.1)
      raise "AJAX request took longer than 5 seconds." if counter >= 50
    end

    sleep 2
  end

  def page_has_selector?(selector)
    browser.all(selector).count > 0
  end

  def fill(text_field_selector, value)
    browser.find(text_field_selector).set(value)
  end

  def click(selector, opts = {})
    click_using_js_event = opts.delete(:using_js_event)
    if click_using_js_event
      browser.find(selector).trigger("click")
    else
      browser.find(selector).click
    end
  end

  private

  def options
    @options
  end
end

class Signup < BrowserSession
  def initialize(opts = {})
    host = opts.delete(:host) || "http://jibjob.co"
    super(opts.merge(host: host))
  end

  def run!
    username = "#{Faker::Internet.user_name}_#{SecureRandom.hex(2)}"

    visit "/app/users/new"
    fill "#user_username", username
    fill "#user_email", "virgild+#{username}@gmail.com"
    fill "#user_password", "applesauce"
    fill "#user_password_confirmation", "applesauce"
    browser.check "user_terms"
    browser.click_on "Submit"
  end
end

class CreateResume < BrowserSession
  attr_reader :username

  def initialize(opts = {})
    host = opts.delete(:host) || "http://jibjob.co"
    @username = opts.delete(:username)
    set_password(opts.delete(:password))

    super(opts.merge(host: host))
  end

  def login!
    # Login
    visit "/app/login"
    browser.fill_in "username", with: username
    browser.fill_in "password", with: password
    browser.click_on "Submit"
  end

  def create_resume!
    # Create
    visit "/app/users/#{username}/resumes"
    perform_when_present('#create-button') do
      browser.click_on "create-button"
      browser.fill_in "Name", with: Faker::Commerce.product_name
      browser.fill_in "Content", with: "#N #{Faker::Name.name}"
      browser.click_on "Load Example"
      wait_for_ajax

      browser.click_on "Save Resume"
      wait_for_ajax
    end
  end

  def create_resumes!(count = 10)
    (1..count).each do
      begin
        create_resume!
      rescue Exception => error
        puts error
      end
    end
  end

  private

  def password
    @password
  end

  def set_password(value)
    @password = value
  end
end

def create_resume_routine
  user_pool = ["quinn_bosco", "aunta_murphy", "leanne", "chelsie_donnelly", "everette", "gabriella", "caitlyn", "geraldine", "virginie", "rogelio", "justen", "keven_stark", "cale_schumm", "aurelia_ortiz", "consuelo", "laurel", "imani_will", "chase_wyman", "carey_stark", "wallace_pfeffer", "justice", "obie_schmitt", "alek_leffler", "albertha_ratke", "augustus", "simone", "parker", "laurie", "constance", "laurianne", "zoey_hintz", "carroll_reichert", "dashawn_mayer", "karlee_harris", "eddie_crooks", "stephania_abshire", "lucile_zulauf", "timmothy", "gwendolyn", "rafael", "lonzo_gerhold", "corine", "mariela", "leonie", "osborne", "brannon", "enrique", "rebekah", "elinor", "fredrick", "elody_medhurst", "yeenia_pouros", "savannah_considine", "porter_considine", "theresia", "beulah_bosco", "braulio", "rozella", "graciela", "bertha", "josefina", "brennan", "katrine", "marina", "obie_littel", "madison_kshlerin", "america", "lincoln", "orlando", "elisabeth", "darien_bogan", "donald", "blanche", "torrey_jaskolski", "albertha", "angie_larkin", "sienna", "modesto_macejkovic", "cierra_kris", "corbin", "juanita", "keshawn", "francis", "hilton_oberbrunner", "noemie_rohan", "drake_konopelski", "elton_swift", "lori_willms", "else_damore", "carolanne", "krystel", "maureen_zemlak", "marcus", "adriel", "gia_fay", "josh_hilpert", "golden_paucek", "floie_deckow", "eldora", "brandt_ohara", "katharina", "alayna_tromp", "ruth_heller", "bryce_adams", "vincenza", "jerad_carter", "clotilde", "modesto_wolf", "frida_leannon", "brionna", "fausto", "arturo_brakus", "reagan", "christ_harvey", "randy_crist", "karianne_goldner", "edward", "tyshawn", "yvette", "violet", "candice", "murphy", "alfreda", "hollie", "ansley_shields", "romaine", "stephanie_veum", "joanne_wilkinson", "kenny_gislason", "gerhard", "evans_jast", "katelin", "stanford_monahan", "federico_hilpert", "eriberto", "frank_ondricka", "shyann", "philip", "chelsea", "jenifer", "rosalinda_waters", "dalton_mohr", "alford", "zita_haag", "johnnie", "margarita_mayer", "chadrick", "katelynn_kohler", "zackery", "pierce_streich", "karina", "clementine_lesch", "jordyn", "luther", "alexandro_kuhn", "keara_ullrich", "blair_kunze", "claria", "laurence", "clementina_bednar", "wilford", "clay_wolff", "bertram", "skylar_kilback", "lavonne_hegmann", "roberta", "violette_ernser", "adrian_marks", "carlee", "jailyn", "alec_hartmann", "janice_ruecker", "shanny", "loyal_ziemann", "karson_padberg", "trenton_berge", "myrtle_reichel", "amelia", "earnest_medhurst", "joel_kreiger", "emelie", "lenna_leuschke", "gianni", "gabrielle_green", "darlene_rippin", "jaydon", "hunter_pfannerstill", "carole_toy", "stan_grant", "damian", "hildegard", "constantin", "hailey_hintz", "norwood", "virgil_king", "milton", "brooke", "jordon_klocko", "jovan_schumm", "caleigh", "carolyne", "isadore", "valentin_greenholt", "lavada", "jordi_kshlerin", "juliet_okuneva", "sean_shanahan", "elmira", "maximillian", "gillian", "stephan", "valerie", "eloise", "mafalda", "ozella_schmidt", "gerardo", "margarete", "tracey", "dedrick", "elfrieda", "bettie", "simeon", "hillard", "eliza_abbott", "reid_marquardt", "raquel", "kasandra", "ellis_brekke", "alexandrea_quitzon", "nellie_cummings", "jonathon", "daren_kovacek", "marlen_beer", "garrett", "alfred", "carolina_goldner", "josefa_brown", "susana_boyle", "ransom", "horace", "mariane_hand", "allen_smitham", "libby_quitzon", "marina_block", "cleveland_fisher", "christelle", "lonny_mills", "danielle", "burley_cruickshank", "davonte", "sabryna_jakubowski", "maximillia", "jewell", "henderson_ritchie", "mohammad_sauer", "johnny", "carroll_will", "lavina", "florence_ko", "minerva", "fernando_yundt", "eliseo", "wilbert", "madilyn", "stanford_veum", "abigail", "elvera", "delmer", "shea_howell", "celia_feeney", "brenda", "marianna_breitenberg", "adriana", "jovany_barrows", "florida_stiedemann", "rhianna", "alfredo", "genoveva", "tamara_balistreri", "gladys", "alvena", "garry_hartmann", "itzel_stroman", "selmer", "nathanael", "burley", "breanna", "vernie", "kylee_waters", "christa_rodriguez", "jeremie_hudson", "madyson", "georgette_macejkovic", "rosamond_wilderman", "heath_hoeger", "brayan", "lesley", "kristian", "junior", "annamae_stiedemann", "lillian", "bryon_morar", "jaylon_little", "ted_hoppe", "berneice_paucek", "gertrude_kilback", "lauryn_streich", "hester", "aracely_kohler", "nicolas_crist", "meagan_ohara", "chanelle", "shaylee_oconner", "madaline_cole", "victoria", "nicolette_muller", "leatha", "anjali_kihn", "sasha_marvin", "mariam_kilback", "marilie", "jaycee_rosenbaum", "hailee", "roscoe", "jonathan_sipes", "sydni_bosco", "rosendo", "destin", "lon_pfannerstill", "ashton_pacocha", "jaquelin", "marjolaine_emmerich", "rachelle_ratke", "reinhold", "eveline_davis", "winfield", "soledad", "vincenzo_mclaughlin", "martin", "wellington_ferry", "bennett", "kallie_yundt", "jabari", "van_douglas", "jayme_bednar", "mollie", "ezekiel_turcotte", "kaleb_torphy", "maximilian", "gennaro_wyman", "frank_gleason", "darrell", "brooklyn", "victor", "pauline", "sylvia", "cecelia", "mozelle_blick", "citlalli", "tristian", "kaylin", "rogers_wehner", "precious", "nicholas", "catherine", "emerald_lesch", "margarette_bednar", "etha_heidenreich", "gianni_keebler", "eladio_parisian", "hadley", "margarett", "rubye_satterfield", "chance_bode", "immanuel", "delmer_bergnaum", "bethany", "shanelle", "pattie_wolff", "dianna", "darren", "emelia", "hilma_white", "kaandra_wolff", "davin_glover", "rasheed", "rhiannon_bahringer", "ernie_emard", "mckayla_block", "jedediah_kuhlman", "lonzo_crooks", "jeremie", "sage_huels", "pinkie", "corrine", "arianna", "chance_crona", "felicity_herman", "katrina", "camden", "newton", "braeden", "maureen_bailey", "sydney_kaulke", "osvaldo", "daisha", "rebeca", "orie_balistreri", "darrin_langworth", "jennyfer", "lizzie", "triston", "reba_maggio", "leonor_gerlach", "vilma_bahringer", "lionel_parisian", "mazie_moore", "edwina_stark", "desmond", "margaret", "chaz_schiller", "aubree", "lurline", "bernita", "novella", "westley", "serena", "alanna", "ruel_abbott", "geovanni", "maurice", "sierra_rempel", "mark_waelchi", "vada_vandervort", "shirley", "jazmyne", "antwon", "nicolette_cronin", "herminio_davis", "marlon_blick", "doris_willms", "diamond", "adrain", "keenan_hintz", "mariana", "sarina", "floyd_wolff", "oscar_schuster", "stanley", "gielle", "florida", "stewart_beier", "ayla_jones", "xander", "eleanore", "cecelia_kovacek", "jovanny", "adelbert", "kavon_cole", "patricia_lang", "jany_miller", "pearlie", "katelyn", "helena", "mathilde_bashirian", "godfrey_robel", "karlie", "yvonne_fay", "elroy_goyette", "forest", "johathan_kuhn", "antonetta_franecki", "maryjane", "clark_jacobi", "katelyn_hoppe", "amara_leannon", "davin_renner", "hayden_schumm", "arno_smith", "matilda", "gilda_hoeger", "verlie", "faustino", "adaline_pollich", "ignacio", "kaycee_eichmann", "abigayle", "nicola", "kasandra_gutkowski", "estella_reichel", "shanon_ko", "ayana_stamm", "samara", "kaycee_connelly", "carter_cain", "lindsey", "selena", "renee_walter", "emmalee", "connie_mertz", "summer", "sydney_kuhn", "marietta", "ottilie_trantow", "lauriane_littel", "shawn_rippin", "einar_treutel", "herminia", "justus", "berry_green", "austin", "iac_turcotte", "adrian_roob", "maryse", "kiera_parisian", "eunice", "lisette", "willow_mann", "sammy_mckenzie", "marjorie_terry", "fanny_konopelski", "sebastian_brekke", "rodger", "jaunita", "juvenal", "karolann", "kirk_swift", "delaney", "deanna_jakubowski", "jermain", "jacquelyn_eichmann", "willard", "bianka", "brenna", "jordan", "adrian", "damon_barton", "lavon_bashirian", "ezekiel", "abigail_kub", "monserrat_heaney", "retta_batz", "herbert", "mellie", "demetrius_okon", "kellie", "ron_bartoletti", "marcia", "preston_lang", "maybelle", "andreane", "aleandra_sporer", "wilton", "eusebio_wolf", "granville", "rigoberto", "madalyn_auer", "freeda", "nestor_sporer", "gerard", "brent_langworth", "cletus_kerluke", "leila_kovacek", "autumn", "osbaldo_jerde", "jody_miller", "micaela", "esther", "karine", "gloria", "dewayne", "abagail", "janelle", "francisco", "rebeka", "fernando_glover", "william", "fidel_abshire", "lauriane", "terrance", "audreanne_boyle", "damon_stoltenberg", "katheryn", "carroll", "margarett_luettgen", "beryl_christiansen", "amanda", "jaylin_grimes", "trace_borer", "nico_treutel", "jayde_marvin", "thaddeus", "linnea", "stanford", "kaelyn", "oswald", "sedrick", "clifton", "jaron_crist", "braxton", "trevor", "clovis_casper", "zora_conn", "meggie", "forrest", "vada_mayert", "kyla_rohan", "norval", "rosalee_smith", "dustin", "wallace", "miller_altenwerth", "izaiah", "theodore", "arnold_considine", "mauricio_hirthe", "yazmin", "darrion_kilback", "rowena", "hobart", "aliza_cormier", "hailey", "elijah_bartell", "consuelo_christiansen", "junius", "garett", "sheldon", "adrien", "teresa_blanda", "lawson_lesch", "junior_gerhold", "justina", "alison_keebler", "gilbert", "ophelia_miller", "jett_schmeler", "natalia", "breanne_mraz", "phyllis", "brad_bernier", "leta_ward", "ottilie_koch", "mafalda_farrell", "yesenia", "wilson", "mattie_swaniawski", "ozella_turcotte", "morris", "josephine_stanton", "rupert", "regan_brekke", "carole", "maxwell", "domenica", "fleta_funk", "alyson_johnson", "millie", "elaina", "francesco", "camila", "karlee", "gregorio", "donnell_krajcik", "marcel", "conor_crist", "lizzie_murphy", "nikita", "mathias", "abdullah", "xzavier", "dorothy_connelly", "justice_collins", "alivia_bogisich", "charlene_johnson", "trinity", "leonor", "kendall", "antonia", "dashawn_mills", "godfrey", "sheridan", "ernesto", "clara_bartoletti", "abelardo", "brown_mayert", "marilou_pacocha", "giovani_gutkowski", "maeve_gerhold", "elta_little", "alberto", "estefania", "nichole_lueilwitz", "mozelle", "hazel_stamm", "grady_prosacco", "beatrice_marquardt", "domingo", "dangelo", "hardy_jakubowski", "raphaelle_quigley", "della_thompson", "lucious", "madisen", "patience", "beulah", "vida_cummings", "westley_kuphal", "broderick", "maximus_emard", "camila_osinski", "foster", "lafayette", "hal_yost", "leopoldo", "joesph_rowe", "durward", "aniya_mclaughlin", "dahlia_fahey", "mustafa_purdy", "alda_wunsch", "willis", "percy_vandervort", "jovani", "adeline_mcglynn", "ellsworth", "mariane", "antonina", "marlen", "leilani", "blanca_gibson", "shawna", "alvina", "quincy", "nikko_goyette", "abraham", "mercedes_marquardt", "margaret_fritsch", "nicole", "allison", "eden_kreiger", "harvey", "alexzander_hyatt", "brittany", "nicklaus_murphy", "gilberto", "garfield_lemke", "kayley", "geovany_mcdermott", "jayson", "remington", "hester_bailey", "jedediah_kshlerin", "general", "georgianna_keler", "jarvis_conroy", "noemi_lynch", "jacklyn_jakubowski", "margaretta", "tina_gislason", "americo_boehm", "marcella", "tyshawn_herzog", "arthur", "dameon", "ronny_feest", "raheem", "ruben_williamson", "rex_bergstrom", "sarai_renner", "dariana", "bryana_donnelly", "stewart", "ollie_hammes", "adeline_wisoky", "brennon", "coleman", "dallas_boyle", "keshaun", "korbin", "minerva_bradtke", "valentina", "syble_cain", "bianka_towne", "kurtis_bruen", "anderson_stiedemann", "marta_ondricka", "christina", "henderson_gleason", "abbigail_pfannerstill", "gabriel", "ubaldo", "benedict", "cecilia_bins", "dusty_rempel", "weldon_barton", "sheila", "raegan_torp", "gaston", "lysanne", "genevieve", "libbie", "otho_vonrueden", "jacinto", "frances_howe", "augustine", "brooks_erdman", "chesley_mcdermott", "hilario_lesch", "maiya_bode", "trudie", "marcelle", "emilio_hansen", "yvette_veum", "audra_sipes", "margret", "ezequiel_moen", "meta_blick", "martine_tremblay", "cynthia_reilly", "chelsea_gleichner", "viola_renner", "jarrod", "delpha", "mozell", "camron", "mohammed", "benton_ziemann", "bernadette", "cordelia", "mauricio", "joanne", "juston", "niko_roob", "zoie_schinner", "alexandria", "stephon", "isabel_quitzon", "elya_rosenbaum", "meagan_balistreri", "emmett", "eugene_abbott", "wilburn", "annabelle_blick", "ignatius", "freeman", "lucas_swift", "nadia_considine", "jeyca_sanford", "cameron", "dillon", "alexie", "mary_turner", "kasandra_parisian", "walton_lesch", "lonzo_mccullough", "damien_jacobson", "luciano", "benedict_kuhlman", "ashtyn", "mark_huel", "donnie", "candelario", "virgil_koepp", "arne_reichert", "trever", "eudora", "laurel_gleason", "stefan_raynor", "mattie", "donnell_kilback", "stefanie", "bryon_considine", "dayana", "lauretta", "adolph", "mathew_schoen", "alivia", "magnolia_klein", "gaetano", "emiliano_langworth", "sebastian_bruen", "jerald", "dakota", "brock_fadel", "craig_macejkovic", "petra_abshire", "edwina", "manuel", "geovanny_cronin", "cristina_stark", "sarah_trantow", "cade_keler", "nia_howell", "katelynn", "pasquale", "ryleigh", "itzel_doyle", "vernon", "arnaldo", "carole_runolfon", "casimer", "arnulfo_yundt", "harold", "tomasa", "cicero", "julianne_lubowitz", "timothy", "stacey", "grayce_ullrich", "aubrey_wisozk", "frederique_kihn", "letha_koelpin", "davin_schulist", "linnea_bode", "garret_hartmann", "cole_romaguera", "kristina_white", "archibald", "matteo_tremblay", "casandra", "mireya_leuschke", "nestor", "isaiah", "vergie", "jany_oreilly", "tony_padberg", "deontae", "odell_padberg", "ronaldo_keebler", "tyrique", "rosanna_torphy", "gielle_steuber", "terrell", "dortha", "vincenzo", "clare_fadel", "erwin_goldner", "annabell", "montana", "anastasia", "miller", "maiya_price", "aurore", "kayleigh_goldner", "tillman", "earline", "wyatt_donnelly", "juston_mante", "percival_hamill", "kaelyn_walsh", "adelia_huel", "margarita_hayes", "francisca_goldner", "willard_brown"]
  semaphore = Mutex.new
  thread_count = 10
  threads = []
  users_per_thread = 10

  (1..thread_count).each do |thread_index|
    threads << Thread.new {
      users = []

      (1..users_per_thread).each do
        semaphore.synchronize {
          users << user_pool.delete(user_pool.sample)
        }
      end

      puts "Thread #{thread_index} has #{users.join(', ')}"

      users.each do |username|
        puts "Thread #{thread_index} is now processing #{username}"
        s = CreateResume.new(username: username, password: 'applesauce')
        s.login!
        s.create_resumes!(8)
        puts "Thread #{thread_index} is done with #{username}"
      end
    }
  end

  threads.each { |thread| thread.join }
end

def signup_routine
  signup = Signup.new
  (1..50).each do |iteration|
    begin
      signup.clear_cookies!
      signup.run!
    rescue Error => e
      puts e.message
    end
  end
end

if $0 == __FILE__

end