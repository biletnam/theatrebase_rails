user = User.first
theatre = Theatre.first

Production.create!( title:        'Hamlet',
                    alphabetise:  nil,
                    url:          'hamlet',
                    first_date:   '05/08/2015',
                    press_date:   '25/08/2015',
                    last_date:    '31/10/2015',
                    theatre:      theatre,
                    creator:      user,
                    updater:      user)
