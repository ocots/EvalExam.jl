using Plots

function check_box(n::Int, r::Real)
    θ = range(0.0, 2π, length=100)
    x = rT .* cos.(θ)
    y = rT .* sin.(θ)
    return x, y
end

# cadre A4
