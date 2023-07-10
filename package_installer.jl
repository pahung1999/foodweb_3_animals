using Pkg

pkgs = ["Colors", "Agents", "Images", "Distributions"]

for pkg in pkgs
    Pkg.add(pkg)
end
