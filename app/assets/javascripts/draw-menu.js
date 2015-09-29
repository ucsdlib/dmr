var top_nav =
[
    [
        "Home",
        "http://libraries.ucsd.edu/",
        []
    ],
    [
        "Spaces",
        "http://libraries.ucsd.edu/spaces",
        [
            ["Reserve a Study Room","http://libraries.ucsd.edu/spaces/reserve",[]],
            ["Places to Study","http://libraries.ucsd.edu/spaces/places-to-study",[]],
            ["Computing","http://libraries.ucsd.edu/spaces/computing",[]],
            ["Digital Media Lab (DML)","http://libraries.ucsd.edu/spaces/digital-media-lab",[]],
            ["Overnight Study Commons","http://libraries.ucsd.edu/spaces/overnight-study.html",[]],
            ["Floor Plans","http://libraries.ucsd.edu/spaces/floor-plans",[]]
        ]
    ],
    [
        "Hours",
        "http://libraries.ucsd.edu/hours",
        []
    ],
    [
        "Research Tools",
        "http://libraries.ucsd.edu/tools",
        [
            ["Find Articles","http://libraries.ucsd.edu/tools/articles.html",[]],
            ["Find Books","http://libraries.ucsd.edu/tools/books.html",[]],
            ["Course &amp; Subject Guides","http://libguides.ucsd.edu/",[]],
            ["Databases A-Z","https://libraries.ucsd.edu/info/resources/databases-a-z",[]],
            ["Subjects A-Z","https://libraries.ucsd.edu/info/resources/subjects-a-z",[]]
        ]
    ],
    [
        "Collections",
        "http://libraries.ucsd.edu/collections",
        [
            ["About the Collections","http://libraries.ucsd.edu/collections/about",[]],
            ["Digital Collections","http://library.ucsd.edu/dc",[]],
            ["Special Collections &amp; Archives","http://libraries.ucsd.edu/collections/sca",[]],
            ["Scripps Institution of Oceanography Archives","http://libraries.ucsd.edu/collections/sca/manuscripts/scripps-archives.html",[]],
            ["Recommend a Purchase","http://libraries.ucsd.edu/collections/help-build-our-collections/recommend-a-purchase.html",[]]
        ]
    ],
    [
        "Services",
        "http://libraries.ucsd.edu/services",
        [
            ["Borrowing","http://libraries.ucsd.edu/services/borrowing",[]],
            ["Requesting Books &amp; Articles","http://libraries.ucsd.edu/services/requesting",[]],
            ["Instruction","http://libraries.ucsd.edu/services/instruction",[]],
            ["Off-Campus Access","http://libraries.ucsd.edu/spaces/computing/remote-access",[]],
            ["Printing &amp; Copying","http://libraries.ucsd.edu/spaces/computing/print-copy.html",[]],
            ["Individuals with Disabilities","http://libraries.ucsd.edu/services/services-for-individuals-with-disabilities.html",[]],
            ["Services to the Community","http://libraries.ucsd.edu/services/community",[]],
            ["Research Data Curation Services","http://libraries.ucsd.edu/services/data-curation",[]],
            ["Library Wi-Fi","http://libraries.ucsd.edu/spaces/computing/wireless.html",[]]
        ]
    ],
    [
        "Reserves",
        "http://libraries.ucsd.edu/resources/course-reserves",
        [
            ["Get Your Course Reserves","http://reserves.ucsd.edu",[]],
            ["Put Materials on Course Reserve","http://reserves.ucsd.edu",[]],
            ["Off-Campus Access","http://libraries.ucsd.edu/spaces/computing/remote-access",[]],
            ["Info For Students","http://libraries.ucsd.edu/resources/course-reserves/for-students.html",[]],
            ["Info For Faculty","http://libraries.ucsd.edu/resources/course-reserves/for-faculty.html",[]]
        ]
    ],
    [
        "Catalogs",
        "http://roger.ucsd.edu/",
        [
            ["Search UCSD","http://roger.ucsd.edu/",[]],
            ["Search San Diego","http://circuit.sdsu.edu/",[]],
            ["Search All UCs","http://ucsd.worldcat.org/",[]],
            ["Search Worldwide","http://melvyl.worldcat.org/",[]]
        ]
    ],
    [
        "My Library Account",
        "http://roger.ucsd.edu/patroninfo",
        []
    ],
    [
        "Ask a Librarian",
        "http://libraries.ucsd.edu/help/ask-a-librarian",
        [
            ["Ask by Chat","http://www.questionpoint.org/crs/servlet/org.oclc.home.TFSRedirect?virtcategory=10800",[]],
            ["Ask by Email","http://libraries.ucsd.edu/help/ask-a-librarian/email-a-librarian.html",[]],
            ["Ask by Phone","http://libraries.ucsd.edu/help/ask-a-librarian/phone.html",[]],
            ["Ask by Text","http://libraries.ucsd.edu/help/ask-a-librarian/text.html",[]],
            ["Ask a Subject Librarian","http://libraries.ucsd.edu/contacts/subject-specialists.html",[]]
        ]
    ],
    [
        "Help",
        "http://libraries.ucsd.edu/help",
        [
            ["Ask a Librarian","http://libraries.ucsd.edu/help/ask-a-librarian",[]],
            ["New to the Library?","http://libraries.ucsd.edu/help/new-users.html",[]],
            ["Get Started!","http://libguides.ucsd.edu/getstarted",[]],
            ["Off-Campus&nbsp;Access","http://libraries.ucsd.edu/spaces/computing/remote-access",[]],
            ["Staff Contacts","http://libraries.ucsd.edu/contacts",[]],
            ["Where Can I Find...","http://libraries.ucsd.edu/resources/where-can-i-find.html",[]],
            ["Wireless Help","http://libraries.ucsd.edu/services/wireless",[]]
        ]
    ],
    [
        "Sign Out",
        "/users/sign_out",
    ]
];

function draw_ucsd_menu(menu,id_attr)
{
    if(id_attr)
        {document.write('<ul id="' + id_attr + '">');}
    else
        {document.write('<ul>');}

    for(var i = 0, menu_length = menu.length; i < menu_length; i++)
    {
        var
            label = menu[i][0],
            url = menu[i][1],
            child_menu = menu[i][2];

        document.write('<li><a href="' + url + '">' + label + '</a>');

        if (child_menu.length > 0)
        {
            draw_ucsd_menu(child_menu);
        }

        document.write('</li>');
    }

    document.write('</ul>');
}
