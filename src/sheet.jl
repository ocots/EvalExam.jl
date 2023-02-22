using Plots
using Plots.PlotMeasures
using Printf
using LaTeXStrings

_ratio_sheet() = 297/210
_radius_check_box() = 3
_Δx() = 2.25*_radius_check_box()
_Δy() = 0.6*_Δx()
_xmin() = 0
_xmax() = 210
_ymin() = 0
_ymax() = 297
_width() = 600
_height() = _width()*_ratio_sheet()
_dpi() = 400
_check_box_fontsize() = 5
_label_answer_fontsize() = 10
_linewidth_frame() = 2
_Δx_between_answer() = 2
_Δx_question() = 29*_Δx()
_Δy_question() = 2.4*_Δy()
_Δx_numero() = 4*_Δx()
_Δy_numero() = 19*_Δy()

function frame!(p, xmin=_xmin(), xmax=_xmax(), ymin=_ymin(), ymax=_ymax(); background=:white, linewidth=_linewidth_frame())
    plot!(p, [xmin, xmax, xmax, xmin, xmin], [ymin, ymin, ymax, ymax, ymin], 
        color=:black, linewidth=linewidth, fillcolor=background, seriestype=:shape)
end

function blanck_sheet(w=_width(), h=_height(), xmin=_xmin(), xmax=_xmax(), ymin=_ymin(), ymax=_ymax(), dpi=_dpi())
    p = plot(background_color=:white, legend=false, aspect_ratio=:equal, 
        size=(w,h), framestyle=:none, 
        left_margin=-5mm, bottom_margin=-10mm, top_margin=-5mm, right_margin=-1mm,
        xlims=(xmin, xmax), ylims=(ymin, ymax), dpi=dpi
    )
    frame!(p)
    return p
end

function check_box!(p, pos, n::Int, r::Real=_radius_check_box(), fs=_check_box_fontsize())
    #
    θ = range(0.0, 2π, length=100)
    x = pos[1] .+ r .* cos.(θ)
    y = pos[2] .+ r .* sin.(θ)
    plot!(p, x, y, color=:black)
    #
    txt = @sprintf("%d", n)
    plot!(p, annotation=((pos[1], pos[2], txt)), 
        annotationcolor=:black, annotationfontsize=fs, annotationhalign=:center)
end

function check_boxes!(p, pos, r::Real=_radius_check_box(), Δx::Real=_Δx(), fs=_check_box_fontsize())
    check_box!(p, pos, 0, r, fs); pos+=[Δx, 0]
    check_box!(p, pos, 20, r, fs); pos+=[Δx, 0]
    check_box!(p, pos, 60, r, fs); pos+=[Δx, 0]
    check_box!(p, pos, 80, r, fs); pos+=[Δx, 0]
    check_box!(p, pos, 100, r, fs); pos+=[Δx, 0]
end

function answer!(p, label, pos, 
    r::Real=_radius_check_box(), Δx::Real=_Δx(), Δy::Real=_Δy(),
    fs=_check_box_fontsize(), laf=_label_answer_fontsize())
    #
    xmin = pos[1]
    ymin = pos[2]
    xmax = pos[1]+6.2*Δx
    ymax = pos[2]+2*Δy
    #
    frame!(p, xmin, xmax, ymin, ymax, linewidth=1.0)
    #
    plot!(p, annotation=((pos[1]+0.5*Δx, pos[2]+Δy, label)), 
            annotationcolor=:black, annotationfontsize=laf, annotationhalign=:center)
    #
    pos+=[1.5*Δx, Δy]
    check_boxes!(p, pos, r, Δx, fs)
    #
    return [xmax, ymin]
end

function question!(p, label, pos, 
    r::Real=_radius_check_box(), Δx_between_answer::Real=_Δx_between_answer(), 
    Δx::Real=_Δx(), Δy::Real=_Δy(), fs=_check_box_fontsize(),
    laf=_label_answer_fontsize(), 
    Δx_question=_Δx_question(), Δy_question=_Δy_question();
    background=:white)
    #
    xmin = pos[1]
    ymin = pos[2]
    xmax = pos[1] + Δx_question
    ymax = pos[2] + Δy_question
    #
    frame!(p, xmin, xmax, ymin, ymax, linewidth=1.0, background=background)
    #
    plot!(p, annotation=((pos[1]+Δx, pos[2]+1.2*Δy, label)), 
            annotationcolor=:black, annotationfontsize=laf, annotationhalign=:center)
    #
    pos+=[2*Δx, 0]
    labels_answer = ["A", "B", "C", "D"]
    for la ∈ labels_answer
        pos = answer!(p, latexstring(la), pos, r, Δx, Δy, fs, laf)
        pos+=[Δx_between_answer, 0]
    end
    return [xmin, ymin-Δy_question]
end

function questions!(p, pos::Vector{<:Real}, labels::Vector{String})
    background=:white
    for label ∈ labels
        pos = question!(p, latexstring(label), pos, background=background)
        background = background===:white ? :lightgray : :white
    end
end

function column!(p, pos, n,
    r::Real=_radius_check_box(), Δx::Real=_Δx(), fs=_check_box_fontsize())
    for i ∈ range(0, n)
        check_box!(p, pos, i, r, fs); pos-=[0, Δx]
    end
end

function numero!(p, pos, Δx_numero = _Δx_numero(), Δy_numero = _Δy_numero(),
    r::Real=_radius_check_box(), Δx::Real=_Δx(), fs=_check_box_fontsize(),
    laf=_label_answer_fontsize())
    #
    xmin = pos[1]
    ymin = pos[2]
    xmax = pos[1] + Δx_numero
    ymax = pos[2] + Δy_numero
    #
    frame!(p, xmin, xmax, ymin, ymax, linewidth=1.0)
    #
    plot!(p, annotation=((0.5*(xmin+xmax), ymax-0.5*Δx, L"Numéro")), 
    annotationcolor=:black, annotationfontsize=laf, 
    annotationhalign=:center, annotationvalign=:center)
    #
    column!(p, [xmin+1*Δx, ymax-1.6*Δx], 1, r, Δx, fs)
    column!(p, [xmin+2*Δx, ymax-1.6*Δx], 9, r, Δx, fs)
    column!(p, [xmin+3*Δx, ymax-1.6*Δx], 9, r, Δx, fs)
end

#
xx = 8
yy = 200

#
p = blanck_sheet()

#
labels = ["1a", "1b", "1c", "2a", "2b", "2c", "3a", "3b", "3c", 
"4a", "4b", "4c", "5a", "5b", "5c", "6a", "6b", "6c", "7a", "7b"]
questions!(p, [xx, yy], labels[1:end])

# numero/name
Δy_question = _Δy_question()
numero!(p, [xx, yy+1.4*Δy_question])

#
plot!(p)

# save
savefig(p, "sheet.png")