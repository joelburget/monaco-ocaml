(lang dune 2.8)

(name monaco)

(version 0.0.1)

(generate_opam_files true)

(license ISC)

(authors "Joel Burget")

(maintainers "joelburget@gmail.com")

(package
 (name monaco)
 (synopsis "Bindings for Microsoft's Monaco editor")
 (description "TODO")
 (depends
  (brr
   (>= 0.0.1))))

(package
 (name require)
 (synopsis "Simple JavaScript loader bindings")
 (description "TODO")
 (depends
  (brr
   (>= 0.0.1))))
